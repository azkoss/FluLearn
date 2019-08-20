import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

import '../config/constant.dart';
import '../manager/app_manager.dart';
import '../util/common_utils.dart';
import '../util/route_utils.dart';
import '../util/toast_utils.dart';
import '../widget/title_bar.dart';

///
/// 网页浏览器
///
class BrowserPage extends StatefulWidget {
  const BrowserPage({
    Key key,
    @required this.url,
    @required this.title,
    this.changeTitle = true,
  }) : super(key: key);

  final String url;
  final String title;
  final bool changeTitle;

  @override
  _BrowserPageState createState() => new _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  InAppWebViewController _controller;
  String _title = "";
  double _progress = 0;

  @override
  void initState() {
    _title = widget.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //监听左上角按钮返回和实体键返回
    return WillPopScope(
      onWillPop: _goBack,
      child: Scaffold(
        appBar: LyjTitleBar(
          title: widget.changeTitle ? _title : widget.title,
          actionName: "关闭",
          onPressed: () {
            RouteUtils.goBack(context);
          },
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 2,
              child: _progress == 1.0
                  ? null
                  : LinearProgressIndicator(
                      value: _progress,
                    ),
            ),
            Expanded(
              child: InAppWebView(
                initialUrl: widget.url,
                initialHeaders: {},
                initialOptions: {
                  "userAgent": Constant.userAgent,
                  "javaScriptEnabled": true,
                  "domStorageEnabled": true,
                  "databaseEnabled": false,
                  "useShouldOverrideUrlLoading": true,
                  "useOnLoadResource": false,
                  "mixedContentMode": "MIXED_CONTENT_ALWAYS_ALLOW",
                },
                onWebViewCreated: (InAppWebViewController controller) {
                  _controller = controller;
                  AppManager.logger.d("web view created");
                },
                shouldOverrideUrlLoading:
                    (InAppWebViewController controller, String url) {
                  AppManager.logger.d("should override url loading: $url");
                  if (url.startsWith(Constant.scheme)) {
                    RouteUtils.push(context, url);
                    return;
                  }
                  if (url.startsWith("http") || url.startsWith("ftp")) {
                    if (url.endsWith(".apk")) {
                      ToastUtils.showShort("不支持APK下载");
                      return;
                    }
                    controller.loadUrl(url);
                    return;
                  }
                  if (url.startsWith("tel")) {
                    CommonUtils.callPhone(url);
                    return;
                  }
                  AppManager.logger.d('Url Scheme 未知，阻止加载： $url');
                },
                onLoadResource: (InAppWebViewController controller,
                    WebResourceResponse response,
                    WebResourceRequest request) {},
                onLoadStart: (InAppWebViewController controller, String url) {
                  AppManager.logger.d("page started: url=$url");
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    this._progress = progress / 100;
                  });
                },
                onConsoleMessage: (InAppWebViewController controller,
                    ConsoleMessage consoleMessage) {},
                onLoadError: (InAppWebViewController controller, String url,
                    int code, String message) {
                  setState(() {
                    this._progress = 1.0;
                  });
                  AppManager.logger
                      .d("page error: url=$url, code=$code, message=$message");
                },
                onLoadStop: (InAppWebViewController controller, String url) {
                  controller.getTitle().then((String title) {
                    setState(() {
                      this._progress = 1.0;
                      this._title = title;
                      AppManager.logger
                          .d("page stopped: url=$url, title=$title");
                    });
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _goBack() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    }
    return new Future.value(true);
  }
}
