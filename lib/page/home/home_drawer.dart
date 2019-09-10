import 'package:flutter/material.dart' hide LicensePage;
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/page/about/about_page.dart';
import 'package:flutter_app/page/settings_page.dart';
import 'package:flutter_app/util/overlay_style.dart';
import 'package:flutter_app/util/route_navigator.dart';
import 'package:flutter_app/util/toaster.dart';
import 'package:flutter_app/widget/avatar.dart';
import 'package:flutter_app/widget/scroll_drawer.dart';

///
/// 主页抽屉
///
class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollDrawer(
      color: Theme.of(context).backgroundColor,
      widthPercent: 0.7,
      child: Column(
        children: <Widget>[
          _buildHeader(context),
          _buildBody(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          Avatar(
            url: "https://avatars3.githubusercontent.com/u/16816717?s=460&v=4",
            width: 60,
            height: 60,
            onTap: () => Toaster.showShort("用户头像"),
          ),
          Container(height: 10),
          Center(
            child: Text(
              "穿青人",
              style: TextStyle(
                  color: OverlayStyle.estimateFrontColor(
                      Theme.of(context).primaryColor)),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(child: Text("网")),
            title: Text('网页浏览器'),
            onTap: () {
              return RouteNavigator.goWeb(
                  context, "http://github.com/chaunqingren");
            },
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(child: Text("404")),
            title: Text('Page Not Found'),
            subtitle: Text("Drawer item B subtitle"),
            onTap: () {
              return RouteNavigator.goPath(context, "/404");
            },
          ),
          Divider(height: 10),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(S.of(context).titleSettings),
            trailing: new Icon(Icons.chevron_right),
            onTap: () {
              return RouteNavigator.goPage(context, new SettingsPage());
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(S.of(context).titleAbout),
            trailing: new Icon(Icons.chevron_right),
            onTap: () {
              return RouteNavigator.goPage(context, new AboutPage());
            },
          ),
        ],
      ),
    );
  }
}
