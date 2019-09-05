import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_app/util/logger.dart';
import 'package:flutter_app/widget/state_layout.dart';
import 'package:flutter_app/widget/title_bar.dart';

///
/// 路由定义接口约束
///
abstract class IRouterDefinition {
  void defineRouter(Router router);
}

///
/// 路由跳转工具类
/// Adapted from https://github.com/simplezhli/flutter_deer/.../NavigatorUtils.dart
///
class RouteNavigator {
  static const transitionDurationSeconds = 250;
  static final Router router = new Router();

  ///
  /// 模块自己的路由由模块自己管理，统一在程序入口[main()]里进行路由注册
  ///
  static void registerRouter(List<IRouterDefinition> routerProviders) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          L.e("未找到目标页：" + params.toString());
          return Scaffold(
            appBar: TitleBar(
              title: "页面不存在",
            ),
            body: const StateLayout(
              type: StateType.error,
              hintText: "页面不存在",
            ),
          );
        });
    routerProviders.forEach((routerProvider) {
      routerProvider.defineRouter(router);
    });
  }

  ///
  ///打开新页面
  ///
  static goPath(BuildContext context, String path,
      {bool replace = false, bool clearStack = false}) {
    L.d("open route: path=" + path);
    router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transitionDuration: Duration(seconds: transitionDurationSeconds),
        transition: TransitionType.cupertino);
  }

  ///
  ///打开新页面,返回上一页时携带参数
  ///
  static goResult(BuildContext context, String path, Function(Object) function,
      {bool replace = false, bool clearStack = false}) {
    L.d("open route for result: path=" + path);
    router
        .navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transitionDuration: Duration(seconds: transitionDurationSeconds),
        transition: TransitionType.cupertino)
        .then((result) {
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((error) {
      print("$error");
    });
  }

  ///
  ///打开新页面
  ///
  static goPage(BuildContext context, Widget page) {
    L.d("open page: page=" + page.toString());
    Navigator.push(context, new CupertinoPageRoute(builder: (context) {
      return page;
    }));
  }

  ///
  /// 返回
  ///
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  ///
  /// 带参数返回
  ///
  static void goBackWithParams(BuildContext context, result) {
    Navigator.pop(context, result);
  }
}
