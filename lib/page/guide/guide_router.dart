import 'package:fluro/fluro.dart';
import 'package:flutter_app/config/route_url.dart';
import 'package:flutter_app/page/guide/guide_page.dart';
import 'package:flutter_app/util/route_navigator.dart' show IRouterDefinition;

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
