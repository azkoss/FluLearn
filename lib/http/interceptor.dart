import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_app/common/prefs_key.dart';
import 'package:flutter_app/util/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'error_handle.dart';

///
/// 网络请求/响应拦截器
/// Adapted from https://github.com/simplezhli/flutter_deer/.../intercept.dart
///

///
/// 认证鉴权拦截器
///
class AuthInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String accessToken = sp.getString(PrefsKey.access_token);
    if (accessToken.isNotEmpty) {
      options.headers["Authorization"] =
      "Bearer ${sp.getString(PrefsKey.access_token)}";
    }
    return super.onRequest(options);
  }
}

///
/// 调试日志打印拦截器
///
class LoggingInterceptor extends Interceptor {
  DateTime startTime;
  DateTime endTime;

  @override
  onRequest(RequestOptions options) {
    startTime = DateTime.now();
    L.d("----------Start----------");
    if (options.queryParameters.isEmpty) {
      L.d("RequestUrl: " + options.baseUrl + options.path);
    } else {
      L.d("RequestUrl: " +
          options.baseUrl +
          options.path +
          "?" +
          Transformer.urlEncodeMap(options.queryParameters));
    }
    L.d("RequestMethod: " + options.method);
    L.d("RequestHeaders:" + options.headers.toString());
    L.d("RequestContentType: ${options.contentType}");
    L.d("RequestData: ${options.data.toString()}");
    return super.onRequest(options);
  }

  @override
  onResponse(Response response) {
    endTime = DateTime.now();
    int duration = endTime.difference(startTime).inMilliseconds;
    if (response.statusCode == ExceptionHandle.success) {
      L.d("ResponseCode: ${response.statusCode}");
    } else {
      L.e("ResponseCode: ${response.statusCode}");
    }
    // 输出结果
    L.d(response.data.toString());
    L.d("----------End: $duration 毫秒----------");
    return super.onResponse(response);
  }

  @override
  onError(DioError err) {
    L.e("----------Error-----------", err.stackTrace);
    return super.onError(err);
  }
}

///
/// 数据结构适配拦截器
///
class AdapterInterceptor extends Interceptor {
  static const String MSG = "msg";
  static const String SLASH = "\"";
  static const String MESSAGE = "message";

  static const String DEFAULT = "\"无返回信息\"";
  static const String NOT_FOUND = "未找到查询信息";

  @override
  onResponse(Response response) {
    Response r = _adapterData(response);
    return super.onResponse(r);
  }

  @override
  onError(DioError err) {
    if (err.response != null) {
      _adapterData(err.response);
    }
    return super.onError(err);
  }

  Response _adapterData(Response response) {
    String result;
    String content = response.data == null ? "" : response.data.toString();

    /// 成功时，直接格式化返回
    if (response.statusCode == ExceptionHandle.success ||
        response.statusCode == ExceptionHandle.success_not_content) {
      if (content == null || content.isEmpty) {
        content = DEFAULT;
      }
      result = "{\"code\":0,\"data\":$content,\"message\":\"\"}";
      response.statusCode = ExceptionHandle.success;
    } else {
      String msg = "";
      if (response.statusCode == ExceptionHandle.not_found) {
        response.statusCode = ExceptionHandle.success;
        msg = NOT_FOUND;
      } else {
        if (content == null || content.isEmpty) {
          // 一般为网络断开等异常
          response.statusCode = ExceptionHandle.success;
          result = content;
        } else {
          try {
            content = content.replaceAll("\\", "");
            if (SLASH == content.substring(0, 1)) {
              content = content.substring(1, content.length - 1);
            }
            Map<String, dynamic> map = json.decode(content);
            if (map.containsKey(MESSAGE)) {
              msg = map[MESSAGE];
            } else if (map.containsKey(MSG)) {
              msg = map[MSG];
            } else {
              msg = "未知异常";
            }
            // 401 token失效时，单独处理，其他一律为成功
            if (response.statusCode == ExceptionHandle.unauthorized) {
              response.statusCode = ExceptionHandle.unauthorized;
            } else {
              response.statusCode = ExceptionHandle.success;
            }
          } catch (e) {
            L.d("异常信息：$e");
            // 解析异常直接按照返回原数据处理（一般为返回500,503 HTML页面代码）
            msg = "服务器异常";
          }
        }
      }

      /// 错误数据格式化后，按照成功数据返回
      result = "{\"code\":$response.statusCode,\"message\":\"$msg\"}";
    }
    response.data = result;
    return response;
  }
}

///
/// 缓存拦截器，参阅 https://book.flutterchina.club/chapter15/network.html
///
class CacheInterceptor extends Interceptor {}
