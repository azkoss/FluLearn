import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/route_url.dart';
import 'package:flutter_app/toolkit/route_navigator.dart' show IRouterDefinition;
import 'package:flutter_app/ui/login/login_page.dart';

///
/// 登录页路由
///
class LoginRouter implements IRouterDefinition {
  @override
  void defineRouter(Router router) {
    router.define(RouteUrl.login, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new LoginPage();
    }));
  }
}
