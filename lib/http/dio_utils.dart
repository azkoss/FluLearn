import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../config/constant.dart';
import '../manager/app_manager.dart';
import 'api.dart';
import 'entity_factory.dart';
import 'error_handle.dart';
import 'interceptor.dart';
import 'response.dart' as HttpRes;

///
/// 网络请求工具类
/// Adapted from https://github.com/simplezhli/flutter_deer/.../dio_utils.dart
///
class DioUtils {
  static final DioUtils _singleton = DioUtils._internal();

  static DioUtils get instance => DioUtils();

  factory DioUtils() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  DioUtils._internal() {
    var options = BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 15000,
      responseType: ResponseType.plain,
      validateStatus: (status) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
      baseUrl: Api.baseUrl,
      contentType:
          ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8'),
    );
    _dio = Dio(options);

//    /// Fiddler抓包代理配置 https://www.jianshu.com/p/d831b1f7c45b
//    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//        (HttpClient client) {
//      client.findProxy = (uri) {
//        //proxy all request to localhost:8888
//        return "PROXY 10.41.0.132:8888";
//      };
//      client.badCertificateCallback =
//          (X509Certificate cert, String host, int port) => true;
//    };

    /// 统一添加身份验证请求头
    _dio.interceptors.add(AuthInterceptor());

    /// 打印Log(生产模式去除)
    if (Constant.isDebug) {
      _dio.interceptors.add(LoggingInterceptor());
    }

    /// 适配数据(根据自己的数据结构，可自行选择添加)
    _dio.interceptors.add(AdapterInterceptor());
  }

  // 数据返回格式统一，统一处理异常
  Future<HttpRes.Response<T>> _request<T>(String method, String url,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options}) async {
    var response = await _dio.request(url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);

    int _code;
    String _msg;
    T _data;

    try {
      Map<String, dynamic> _map =
          await compute(parseData, response.data.toString());
      _code = _map["code"];
      _msg = _map["message"];
      if (_map.containsKey("data")) {
        if (T.toString() == "String") {
          _data = _map["data"].toString() as T;
        } else if (T.toString() == "Map<dynamic, dynamic>") {
          _data = _map["data"] as T;
        } else {
          _data = EntityFactory.generate(_map["data"]);
        }
      }
    } catch (e) {
      print(e);
      return HttpRes.Response(ExceptionHandle.parse_error, "数据解析错误", _data);
    }
    return HttpRes.Response(_code, _msg, _data);
  }

  Future<HttpRes.Response<List<T>>> _requestList<T>(String method, String url,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options}) async {
    var response = await _dio.request(url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);
    int _code;
    String _msg;
    List<T> _data = [];

    try {
      Map<String, dynamic> _map =
          await compute(parseData, response.data.toString());
      _code = _map["code"];
      _msg = _map["message"];
      if (_map.containsKey("data")) {
        (_map["data"] as List).forEach((item) {
          _data.add(EntityFactory.generate<T>(item));
        });
      }
    } catch (e) {
      print(e);
      return HttpRes.Response(ExceptionHandle.parse_error, "数据解析错误", _data);
    }
    return HttpRes.Response(_code, _msg, _data);
  }

  Options _checkOptions(method, options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    return options;
  }

  Future request<T>(Method method, String url,
      {Function(T t) onSuccess,
      Function(int code, String mag) onError,
      dynamic params,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options}) async {
    String m = _getRequestMethod(method);
    return await _request<T>(m, url,
            data: params,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken)
        .then((HttpRes.Response<T> result) {
      if (result.code == 0) {
        if (onSuccess != null) {
          onSuccess(result.data);
        }
      } else {
        _onError(result.code, result.message, onError);
      }
    }, onError: (e, _) {
      _cancelLogPrint(e, url);
      Error error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  Future requestList<T>(Method method, String url,
      {Function(List<T> t) onSuccess,
      Function(int code, String mag) onError,
      dynamic params,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options}) async {
    String m = _getRequestMethod(method);
    return await _requestList<T>(m, url,
            data: params,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken)
        .then((HttpRes.Response<List<T>> result) {
      if (result.code == 0) {
        if (onSuccess != null) {
          onSuccess(result.data);
        }
      } else {
        _onError(result.code, result.message, onError);
      }
    }, onError: (e, _) {
      _cancelLogPrint(e, url);
      Error error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  /// 统一处理(onSuccess返回T对象，onSuccessList返回List<T>)
  requestNetwork<T>(Method method, String url,
      {Function(T t) onSuccess,
      Function(List<T> list) onSuccessList,
      Function(int code, String mag) onError,
      dynamic params,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options,
      bool isList: false}) {
    String m = _getRequestMethod(method);
    Observable.fromFuture(isList
            ? _requestList<T>(m, url,
                data: params,
                queryParameters: queryParameters,
                options: options,
                cancelToken: cancelToken)
            : _request<T>(m, url,
                data: params,
                queryParameters: queryParameters,
                options: options,
                cancelToken: cancelToken))
        .asBroadcastStream()
        .listen((result) {
      if (result.code == 0) {
        if (isList) {
          if (onSuccessList != null) {
            onSuccessList(result.data);
          }
        } else {
          if (onSuccess != null) {
            onSuccess(result.data);
          }
        }
      } else {
        _onError(result.code, result.message, onError);
      }
    }, onError: (e) {
      _cancelLogPrint(e, url);
      Error error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  _cancelLogPrint(dynamic e, String url) {
    if (e is DioError && CancelToken.isCancel(e)) {
      AppManager.logger.d("取消请求接口： $url");
    }
  }

  _onError(int code, String msg, Function(int code, String mag) onError) {
    AppManager.logger.e("接口请求异常： code: $code, mag: $msg");
    if (onError != null) {
      onError(code, msg);
    }
  }

  String _getRequestMethod(Method method) {
    String m;
    switch (method) {
      case Method.get:
        m = "GET";
        break;
      case Method.post:
        m = "POST";
        break;
      case Method.put:
        m = "PUT";
        break;
      case Method.patch:
        m = "PATCH";
        break;
      case Method.delete:
        m = "DELETE";
        break;
      case Method.head:
        m = "HEAD";
        break;
    }
    return m;
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data);
}

enum Method { get, post, put, patch, delete, head }
