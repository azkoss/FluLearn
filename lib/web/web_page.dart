import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../config/constant.dart';
import '../manager/app_manager.dart';
import '../util/route_utils.dart';
import '../widget/app_bar.dart';

///
/// 网页加载
///
class WebPage extends StatefulWidget {
  const WebPage({
    Key key,
    @required this.title,
    @required this.url,
  }) : super(key: key);

  final String title;
  final String url;

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool _pageFinished = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (context, snapshot) {
          //监听左上角按钮返回和实体键返回
          return WillPopScope(
            onWillPop: () async {
              if (snapshot.hasData) {
                bool canGoBack = await snapshot.data.canGoBack();
                if (canGoBack) {
                  _notifyPageLoadStart();
                  snapshot.data.goBack();
                  return Future.value(false);
                }
                return Future.value(true);
              }
              return Future.value(true);
            },
            child: Scaffold(
              appBar: LyjAppBar(
                centerTitle: widget.title,
                actionName: "关闭",
                onPressed: () {
                  RouteUtils.goBack(context);
                },
              ),
              body: Column(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 2,
                    child: _pageFinished ? null : LinearProgressIndicator(),
                  ),
                  Expanded(
                    child: WebView(
                      debuggingEnabled: Constant.isDebug,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: widget.url,
                      userAgent: Constant.userAgent,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller.complete(webViewController);
                        AppManager.logger.d("web view created");
                      },
                      navigationDelegate: (NavigationRequest request) {
                        String url = request.url;
                        if (url.startsWith(Constant.scheme) ||
                            url.startsWith("http")) {
                          AppManager.logger.d('允许加载 $request');
                          _notifyPageLoadStart();
                          return NavigationDecision.navigate;
                        }
                        AppManager.logger.d('阻止加载 $request');
                        return NavigationDecision.prevent;
                      },
                      onPageFinished: (String str) {
                        AppManager.logger.d("web page finished: " + str);
                        _notifyPageLoadFinish();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _notifyPageLoadStart() {
    setState(() {
      _pageFinished = false;
    });
  }

  void _notifyPageLoadFinish() {
    setState(() {
      _pageFinished = true;
    });
  }
}
