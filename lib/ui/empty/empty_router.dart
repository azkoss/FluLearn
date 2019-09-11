import 'package:fluro/fluro.dart';
import 'package:flutter_app/config/route_url.dart';
import 'package:flutter_app/toolkit/route_navigator.dart' show IRouterDefinition;
import 'package:flutter_app/ui/empty/empty_page.dart';

///
/// 空页路由
///
class EmptyRouter implements IRouterDefinition {
  @override
  void defineRouter(Router router) {
    router.define(RouteUrl.empty, handler: Handler(handlerFunc: (_, params) {
      return EmptyPage();
    }));
  }
}
