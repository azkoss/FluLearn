import 'package:fluro/fluro.dart';

import '../config/constant.dart';
import '../manager/router_manager.dart' show IRouterProvider;
import 'browser_page.dart';

///
/// 网页浏览器路由
///
class BrowserRouter implements IRouterProvider {
  static String webPage = Constant.scheme + "browser";

  @override
  void initRouter(Router router) {
    router.define(webPage, handler: Handler(handlerFunc: (_, params) {
      String title = params['title']?.first;
      String url = params['url']?.first;
      return new BrowserPage(url: url, title: title);
    }));
  }
}
