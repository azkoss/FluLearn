import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../home/home_router.dart';
import '../web/web_router.dart';
import '../404.dart';

///
/// 路由集中管理
///
class RouteManager {
  static Router router;
  static List<IRouterProvider> _listRouter = [];

  static void configureRoutes(Router router) {
    RouteManager.router = router;
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      debugPrint("未找到目标页");
      return new WidgetNotFound();
    });

    _listRouter.clear();

    /// 各自路由由各自模块管理，统一在此添加初始化
    _listRouter.add(new WebRouter());
    _listRouter.add(new HomeRouter());

    /// 初始化路由
    _listRouter.forEach((routerProvider) {
      routerProvider.initRouter(router);
    });
  }
}

///
/// 路由定义约束
///
abstract class IRouterProvider {
  void initRouter(Router router);
}
