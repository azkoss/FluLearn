import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/route_url.dart';
import 'package:flutter_app/page/web/web_page.dart';
import 'package:flutter_app/util/route_navigator.dart' show IRouterDefinition;

///
/// 网页加载页路由
///
class WebRouter implements IRouterDefinition {
  @override
  void defineRouter(Router router) {
    router.define(RouteUrl.web, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String url = params['url']?.first;
      String title = params['title']?.first;
      //fluro 不支持传中文，需转换
      url = Uri.encodeComponent(url ?? '');
      title = Uri.encodeComponent(title ?? '');
      return new WebPage(url: url, title: title);
    }));
  }
}
