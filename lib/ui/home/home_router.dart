import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/route_url.dart';
import 'package:flutter_app/toolkit/route_navigator.dart' show IRouterDefinition;
import 'package:flutter_app/ui/home/home_page.dart';

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
