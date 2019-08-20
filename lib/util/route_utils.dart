import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../browser/browser_router.dart';
import '../manager/app_manager.dart';

///
/// 路由跳转工具类
///
class RouteUtils {
  ///打开新页面
  static push(BuildContext context, String path,
      {bool replace = false, bool clearStack = false}) {
    AppManager.logger.d("open route: path=" + path);
    FocusScope.of(context).requestFocus(new FocusNode());
    AppManager.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transition: TransitionType.native);
  }

  ///打开新页面,返回上一页时携带参数
  static pushResult(
      BuildContext context, String path, Function(Object) function,
      {bool replace = false, bool clearStack = false}) {
    AppManager.logger.d("open route for result: path=" + path);
    FocusScope.of(context).requestFocus(new FocusNode());
    AppManager.router
        .navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transition: TransitionType.native)
        .then((result) {
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((error) {
      print("$error");
    });
  }

  ///打开新页面
  static goPage(BuildContext context, Widget page) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.push(context, new MaterialPageRoute<Widget>(builder: (context) {
      return page;
    }));
  }

  /// 返回
  static void goBack(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.pop(context);
  }

  /// 带参数返回
  static void goBackWithParams(BuildContext context, result) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.pop(context, result);
  }

  /// 跳到网页
  static goWebPage(BuildContext context, String url, [String title = ""]) {
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
