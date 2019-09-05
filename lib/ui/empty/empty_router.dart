import 'package:fluro/fluro.dart';
import 'package:flutter_app/config/constant.dart';
import 'package:flutter_app/ui/empty/empty_page.dart';
import 'package:flutter_app/util/route_navigator.dart' show IRouterDefinition;

///
/// 空页路由
///
class EmptyRouter implements IRouterDefinition {
  static const String emptyPage = Constant.urlScheme + "empty";

  @override
  void defineRouter(Router router) {
    router.define(emptyPage, handler: Handler(handlerFunc: (_, params) {
      return EmptyPage();
    }));
  }
}
