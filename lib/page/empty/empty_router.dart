import 'package:fluro/fluro.dart';
import 'package:flutter_app/config/route_url.dart';
import 'package:flutter_app/page/empty/empty_page.dart';
import 'package:flutter_app/util/route_navigator.dart' show IRouterDefinition;

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
