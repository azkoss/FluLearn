import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../404.dart';
import '../browser/browser_router.dart';
import '../home/home_router.dart';
import 'app_manager.dart';

///
/// 路由集中管理
///
class RouteManager {
  static List<IRouterProvider> _listRouter = [];

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          AppManager.logger.e("未找到目标页：" + params.toString());
          return new PageNotFound();
    });

    _listRouter.clear();

    /// 各自路由由各自模块管理，统一在此添加初始化
    _listRouter.add(new BrowserRouter());
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
