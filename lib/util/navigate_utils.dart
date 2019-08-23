import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/browser/browser_router.dart';
import 'package:flutter_app/common/application.dart';

///
/// 路由跳转工具类
/// Adapted from https://github.com/simplezhli/flutter_deer/.../NavigatorUtils.dart
///
class NavigateUtils {
  static const transitionDurationSeconds = 250;

  ///
  ///打开新页面
  ///
  static push(BuildContext context, String path,
      {bool replace = false, bool clearStack = false}) {
    Application.logger.d("open route: path=" + path);
    Application.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transitionDuration: Duration(seconds: transitionDurationSeconds),
        transition: TransitionType.cupertino);
  }

  ///
  ///打开新页面,返回上一页时携带参数
  ///
  static pushResult(
      BuildContext context, String path, Function(Object) function,
      {bool replace = false, bool clearStack = false}) {
    Application.logger.d("open route for result: path=" + path);
    Application.router
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
    Application.logger.d("open page: page=" + page.toString());
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

  ///
  /// 跳到网页
  ///
  static goWeb(BuildContext context, String url, [String title = ""]) {
    if (title
        .trim()
        .isEmpty) {
      title = "网页浏览器";
    }
    //fluro 不支持传中文,需转换
    String titleEn = Uri.encodeComponent(title);
    String urlEn = Uri.encodeComponent(url);
    push(context, BrowserRouter.webPage + "?title=$titleEn&url=$urlEn");
  }
}
