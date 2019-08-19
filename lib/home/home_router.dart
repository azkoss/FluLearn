import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../manager/router_manager.dart' show IRouterProvider;
import 'home_page.dart';

///
/// 首页路由
///
class HomeRouter implements IRouterProvider {
  static String homePage = "/home";

  @override
  void initRouter(Router router) {
    router.define(homePage, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new HomePage();
    }));
  }
}
