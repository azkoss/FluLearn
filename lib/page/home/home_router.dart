import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/route_url.dart';
import 'package:flutter_app/page/home/home_page.dart';
import 'package:flutter_app/util/route_navigator.dart' show IRouterDefinition;

///
/// 首页路由
///
class HomeRouter implements IRouterDefinition {
  @override
  void defineRouter(Router router) {
    router.define(RouteUrl.home, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new HomePage();
    }));
  }
}
