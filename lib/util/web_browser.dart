import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/constant.dart';
import 'package:flutter_app/ui/empty/empty_router.dart';
import 'package:flutter_app/util/logger.dart';
import 'package:flutter_app/util/route_navigator.dart';
import 'package:flutter_app/util/url_scheme.dart';
import 'package:flutter_app/widget/title_bar.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

///
/// 网页浏览器
///
class WebBrowser {
  static const Map<String, String> HEADERS = {};
  static const Map<String, Object> OPTIONS = {
    "userAgent": "Mozilla/5.0 (Linux; Android 9; POCOPHONE F1) "
        "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.136 "
        "Mobile Safari/537.36",
    "javaScriptEnabled": true,
    "domStorageEnabled": true,
    "databaseEnabled": true,
    "useShouldOverrideUrlLoading": true,
    "useOnLoadResource": false,
    "mixedContentMode": "MIXED_CONTENT_ALWAYS_ALLOW",
  };

  ///
  /// 加载网页
  ///
  static void launch(BuildContext context, String url, [String title = ""]) {
    if (TextUtil.isEmpty(title)) {
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
    super.initState();
    _title = widget.title;
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
              child: _buildWebView(),
            ),
          ],
        ),
      ),
    );
  }

  InAppWebView _buildWebView() {
    return InAppWebView(
      initialUrl: widget.url,
      initialHeaders: WebBrowser.HEADERS,
      initialOptions: WebBrowser.OPTIONS,
      onWebViewCreated: _onWebViewCreated,
      shouldOverrideUrlLoading: _shouldOverrideUrlLoading,
      onLoadResource: _onLoadResource,
      onLoadStart: _onLoadStart,
      onProgressChanged: _onProgressChanged,
      onConsoleMessage: _onConsoleMessage,
      onLoadError: _onLoadError,
      onLoadStop: _onLoadStop,
    );
  }

  void _onWebViewCreated(InAppWebViewController controller) {
    _controller = controller;
    L.d("web view created");
  }

  void _onLoadStart(InAppWebViewController controller, String url) {
    _notifyLoadStateChanged(true);
    L.d("page started: url=$url");
  }

  void _onLoadError(InAppWebViewController controller, String url, int code,
      String message) {
    _notifyLoadStateChanged(false);
    L.d("page error: url=$url, code=$code, message=$message");
    RouteNavigator.goPath(context, EmptyRouter.emptyPage, replace: true);
  }

  void _onLoadStop(InAppWebViewController controller, String url) {
    _notifyLoadStateChanged(false);
    controller.getTitle().then((String title) {
      setState(() {
        this._title = title;
        L.d("page stopped: url=$url, title=$title");
      });
    });
  }

  void _onProgressChanged(InAppWebViewController controller, int progress) {}

  void _shouldOverrideUrlLoading(InAppWebViewController controller,
      String url) {
    L.d("should override url loading: $url");
    if (url.startsWith(Constant.urlScheme)) {
      RouteNavigator.goPath(context, url);
      return;
    }
    if (url.startsWith("http") || url.startsWith("ftp")) {
      if (url.endsWith(".apk")) {
        L.d('APK下载： $url');
        UrlScheme.tryOpen(url);
        return;
      }
      _notifyLoadStateChanged(true);
      controller.loadUrl(url);
      return;
    }
    L.d('Url Scheme 未知： $url');
    UrlScheme.tryOpen(url);
  }

  void _onLoadResource(InAppWebViewController controller,
      WebResourceResponse response, WebResourceRequest request) {}

  void _onConsoleMessage(InAppWebViewController controller,
      ConsoleMessage consoleMessage) {}

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
