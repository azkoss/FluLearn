import 'package:fluro/fluro.dart';

import '../manager/router_manager.dart' show IRouterProvider;
import '../web/web_page.dart';

///
/// 网页加载器路由
///
class WebRouter implements IRouterProvider {
  static String webPage = "/web";

  @override
  void initRouter(Router router) {
    router.define(webPage, handler: Handler(handlerFunc: (_, params) {
      String title = params['title']?.first;
      String url = params['url']?.first;
      return new WebPage(title: title, url: url);
    }));
  }
}
