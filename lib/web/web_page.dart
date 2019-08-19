import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/widget/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (context, snapshot) {
          return WillPopScope(
            onWillPop: () async {
              if (snapshot.hasData) {
                bool canGoBack = await snapshot.data.canGoBack();
                if (canGoBack) {
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
                ),
                body: WebView(
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                )),
          );
        });
  }
}
