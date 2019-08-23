import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/constant.dart';
import 'package:flutter_app/common/routers.dart' show IRouterProvider;

import 'home_page.dart';

///
/// 首页路由
///
class HomeRouter implements IRouterProvider {
  static String homePage = Constant.urlScheme + "home";

  @override
  void initRouter(Router router) {
    router.define(homePage, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new HomePage();
    }));
  }
}
