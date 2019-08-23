import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/browser/browser_router.dart';
import 'package:flutter_app/empty/empty_page.dart';
import 'package:flutter_app/empty/empty_router.dart';
import 'package:flutter_app/home/home_router.dart';

import 'application.dart';

///
/// 路由集中管理
///
class Routers {
  static List<IRouterProvider> _listRouter = [];

  static void configure(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          Application.logger.e("未找到目标页：" + params.toString());
          return new EmptyPage();
    });

    _listRouter.clear();

    /// 各自路由由各自模块管理，统一在此添加初始化
    _listRouter.add(new EmptyRouter());
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
/// Copy from https://github.com/simplezhli/flutter_deer/.../router_init.dart
///
abstract class IRouterProvider {
  void initRouter(Router router);
}
