import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/util/route_navigator.dart';
import 'package:flutter_app/util/toaster.dart';
import 'package:flutter_app/util/url_scheme.dart';

///
/// 网页加载器右上角弹出菜单
///
class WebActionMenu extends StatelessWidget {
  WebActionMenu({@required this.url}) : assert(url != null);

  final String url;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      onSelected: (String value) {
        if ('close' == value) {
          RouteNavigator.goBack(context);
        } else if ('copy' == value) {
          Clipboard.setData(new ClipboardData(text: url));
          Toaster.showShort(S.of(context).toastCopyWebUrl);
        } else if ('browser' == value) {
          UrlScheme.tryOpen(url);
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<String>>[
          new PopupMenuItem(
            value: "copy",
            child: new Text(S.of(context).webMenuCopyLink),
          ),
          new PopupMenuItem(
            value: "browser",
            child: new Text(S.of(context).webMenuOpenBrowser),
          ),
          new PopupMenuItem(
            value: "close",
            child: new Text(S.of(context).webMenuClose),
          ),
        ];
      },
    );
  }
}
