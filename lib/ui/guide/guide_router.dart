import 'package:fluro/fluro.dart';
import 'package:flutter_app/config/route_url.dart';
import 'package:flutter_app/toolkit/route_navigator.dart' show IRouterDefinition;
import 'package:flutter_app/ui/guide/guide_page.dart';

///
/// 向导页路由
///
class GuideRouter implements IRouterDefinition {
  @override
  void defineRouter(Router router) {
    router.define(RouteUrl.guide, handler: Handler(handlerFunc: (_, params) {
      return GuidePage();
    }));
  }
}
