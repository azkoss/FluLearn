import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/constant.dart';
import 'package:flutter_app/util/route_navigator.dart' show IRouterDefinition;

import 'home_page.dart';

///
/// 首页路由
///
class HomeRouter implements IRouterDefinition {
  static const String homePage = Constant.urlScheme + "home";

  @override
  void defineRouter(Router router) {
    router.define(homePage, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new HomePage();
    }));
  }
}
