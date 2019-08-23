import 'package:fluro/fluro.dart';
import 'package:flutter_app/common/constant.dart';
import 'package:flutter_app/common/routers.dart' show IRouterProvider;
import 'package:flutter_app/empty/empty_page.dart';

///
/// 空页路由
///
class EmptyRouter implements IRouterProvider {
  static String emptyPage = Constant.urlScheme + "empty";

  @override
  void initRouter(Router router) {
    router.define(emptyPage, handler: Handler(handlerFunc: (_, params) {
      return EmptyPage();
    }));
  }
}
