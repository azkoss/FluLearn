import 'package:flutter/material.dart';
import 'package:flutter_app/common/constant.dart';
import 'package:flutter_app/empty/empty_router.dart';
import 'package:flutter_app/util/logger.dart';
import 'package:flutter_app/util/other_tool.dart';
import 'package:flutter_app/util/route_navigator.dart';
import 'package:flutter_app/util/toaster.dart';
import 'package:flutter_app/widget/title_bar.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

///
/// 网页浏览器
///
class WebBrowser {
  ///
  /// 网页加载器代理串
  ///
  static const String userAgent =
      "Mozilla/5.0 (Linux; Android 7.0; PLUS Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.98 Mobile Safari/537.36";

  ///
  /// 加载网页
  ///
  static void launch(BuildContext context, String url, [String title = ""]) {
    if (title.trim().isEmpty) {
      title = "网页浏览器";
    }
    RouteNavigator.goPage(context, new BrowserPage(url: url, title: title));
  }
}

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
  bool _loading = true;

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
        appBar: TitleBar(
          title: widget.changeTitle ? _title : widget.title,
          actionName: "关闭",
          onPressed: () {
            RouteNavigator.goBack(context);
          },
        ),
        body: Column(
          children: <Widget>[
            //当offstage为true隐藏，当offstage为false显示；
            Offstage(
              offstage: !_loading,
              child: SizedBox(
                child: LinearProgressIndicator(),
                width: double.infinity,
                height: 2,
              ),
            ),
            Expanded(
              child: InAppWebView(
                initialUrl: widget.url,
                initialHeaders: {},
                initialOptions: {
                  "userAgent": WebBrowser.userAgent,
                  "javaScriptEnabled": true,
                  "domStorageEnabled": true,
                  "databaseEnabled": false,
                  "useShouldOverrideUrlLoading": true,
                  "useOnLoadResource": false,
                  "mixedContentMode": "MIXED_CONTENT_ALWAYS_ALLOW",
                },
                onWebViewCreated: (InAppWebViewController controller) {
                  _controller = controller;
                  L.d("web view created");
                },
                shouldOverrideUrlLoading:
                    (InAppWebViewController controller, String url) {
                  L.d("should override url loading: $url");
                  if (url.startsWith(Constant.urlScheme)) {
                    RouteNavigator.goPath(context, url);
                    return;
                  }
                  if (url.startsWith("http") || url.startsWith("ftp")) {
                    if (url.endsWith(".apk")) {
                      Toaster.showShort("不支持APK下载");
                      return;
                    }
                    _notifyLoadStateChanged(true);
                    controller.loadUrl(url);
                    return;
                  }
                  if (url.startsWith("tel")) {
                    OtherTool.callPhone(context, url);
                    return;
                  }
                  L.d('Url Scheme 未知，阻止加载： $url');
                },
                onLoadResource: (InAppWebViewController controller,
                    WebResourceResponse response,
                    WebResourceRequest request) {},
                onLoadStart: (InAppWebViewController controller, String url) {
                  _notifyLoadStateChanged(true);
                  L.d("page started: url=$url");
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {},
                onConsoleMessage: (InAppWebViewController controller,
                    ConsoleMessage consoleMessage) {},
                onLoadError: (InAppWebViewController controller, String url,
                    int code, String message) {
                  _notifyLoadStateChanged(false);
                  L.d("page error: url=$url, code=$code, message=$message");
                  RouteNavigator.goPath(context, EmptyRouter.emptyPage,
                      replace: true);
                },
                onLoadStop: (InAppWebViewController controller, String url) {
                  _notifyLoadStateChanged(false);
                  controller.getTitle().then((String title) {
                    setState(() {
                      this._title = title;
                      L.d("page stopped: url=$url, title=$title");
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

  void _notifyLoadStateChanged(bool loading) {
    setState(() {
      _loading = loading;
    });
  }

  Future<bool> _goBack() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    }
    return new Future.value(true);
  }
}
