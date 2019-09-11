import 'package:flutter/material.dart' hide LicensePage;
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/toolkit/image_loader.dart';
import 'package:flutter_app/toolkit/overlay_style.dart';
import 'package:flutter_app/toolkit/route_navigator.dart';
import 'package:flutter_app/toolkit/toaster.dart';
import 'package:flutter_app/ui/about/about_page.dart';
import 'package:flutter_app/ui/settings/settings_page.dart';
import 'package:flutter_app/ui/widget/avatar.dart';
import 'package:flutter_app/ui/widget/scroll_drawer.dart';

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
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ImageLoader.fromProvider('app_logo.png'),
          fit: BoxFit.cover,
        ),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        children: <Widget>[
          Avatar(
            url: "https://avatars3.githubusercontent.com/u/16816717?s=460&v=4",
            width: 60,
            height: 60,
            onTap: () => Toaster.showShort("用户头像"),
          ),
          SizedBox(height: 10),
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
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
          child: Column(
            children: <Widget>[
              Divider(),
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
            ],
          ),
        ),
        SizedBox(height: 8),
        Material(
          child: Column(
            children: <Widget>[
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
              Divider(),
            ],
          ),
        ),
      ],
    );
  }
}
