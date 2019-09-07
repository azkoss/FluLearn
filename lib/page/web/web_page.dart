import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/config/route_url.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/util/logger.dart';
import 'package:flutter_app/util/route_navigator.dart';
import 'package:flutter_app/util/toaster.dart';
import 'package:flutter_app/util/url_scheme.dart';
import 'package:flutter_app/widget/title_bar.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

const Map<String, String> _HEADERS = {};
const Map<String, Object> _OPTIONS = {
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
/// 网页加载页
///
class WebPage extends StatefulWidget {
  const WebPage({
    Key key,
    @required this.url,
    @required this.title,
    this.changeTitle = true,
  }) : super(key: key);

  final String url;
  final String title;
  final bool changeTitle;

  @override
  _WebPageState createState() => new _WebPageState();
}

class _WebPageState extends State<WebPage> {
  InAppWebViewController _controller;
  String _title = "";
  String _url = "";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _url = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    //监听左上角按钮返回和实体键返回
    return WillPopScope(
      onWillPop: _goBack,
      child: Scaffold(
        appBar: TitleBar(
          title: widget.changeTitle ? _title : widget.title,
          actionWidget: _buildPopupMenu(context),
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
              flex: 1,
              child: _buildWebView(),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<String> _buildPopupMenu(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      onSelected: (String value) {
        if ('close' == value) {
          RouteNavigator.goBack(context);
        } else if ('copy' == value) {
          Clipboard.setData(new ClipboardData(text: _url));
          Toaster.showShort(S.of(context).toastCopyWebUrl);
        } else if ('browser' == value) {
          UrlScheme.tryOpen(_url);
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<String>>[
          new PopupMenuItem(
            value: "copy",
            child: new Text(S.of(context).browserCopyUrl),
          ),
          new PopupMenuItem(
            value: "browser",
            child: new Text(S.of(context).browserOpenExternal),
          ),
          new PopupMenuItem(
            value: "close",
            child: new Text(S.of(context).browserClose),
          ),
        ];
      },
    );
  }

  Widget _buildWebView() {
    return InAppWebView(
      initialUrl: widget.url,
      initialHeaders: _HEADERS,
      initialOptions: _OPTIONS,
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

  void _onLoadError(
      InAppWebViewController controller, String url, int code, String message) {
    _notifyLoadStateChanged(false);
    L.d("page error: url=$url, code=$code, message=$message");
    RouteNavigator.goPath(context, RouteUrl.empty, replace: true);
  }

  void _onLoadStop(InAppWebViewController controller, String url) {
    _notifyLoadStateChanged(false);
    controller.getTitle().then((String title) {
      setState(() {
        _title = title;
        L.d("page stopped: url=$url, title=$title");
      });
    });
  }

  void _onProgressChanged(InAppWebViewController controller, int progress) {}

  void _shouldOverrideUrlLoading(
      InAppWebViewController controller, String url) {
    L.d("should override url loading: $url");
    _url = url;
    if (url.startsWith(RouteUrl.scheme)) {
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

  void _onConsoleMessage(
      InAppWebViewController controller, ConsoleMessage consoleMessage) {}

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
