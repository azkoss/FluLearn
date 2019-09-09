import 'package:flutter/material.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/page/settings_page.dart';
import 'package:flutter_app/util/image_loader.dart';
import 'package:flutter_app/util/route_navigator.dart';
import 'package:flutter_app/util/toaster.dart';
import 'package:package_info/package_info.dart';

///
/// 主页抽屉
///
class HomeDrawer extends StatelessWidget {
  HomeDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _buildDrawer(context),
      elevation: 10.0,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: ListView(
        padding: EdgeInsets.zero,
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
          ClipOval(
            child: GestureDetector(
              onTap: () {
                Toaster.showShort("用户头像");
              },
              child: ImageLoader.fromNetwork(
                "https://avatars3.githubusercontent.com/u/16816717?s=460&v=4",
                width: 60,
                height: 60,
              ),
            ),
          ),
          Container(height: 10),
          Center(
            child: Text(
              "穿青人",
              style: TextStyle(),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.blue[300],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: Colors.white,
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
          Divider(
            height: 1,
            color: Colors.grey[350],
          ),
          ListTile(
            leading: CircleAvatar(child: Text("404")),
            title: Text('Page Not Found'),
            subtitle: Text("Drawer item B subtitle"),
            onTap: () {
              return RouteNavigator.goPath(context, "/404");
            },
          ),
          Container(
            width: double.infinity,
            height: 10,
            color: Colors.grey[300],
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(S.of(context).homeDrawerSettings),
            trailing: new Icon(Icons.keyboard_arrow_right),
            onTap: () => _goToSettings(context),
          ),
          Divider(
            height: 1,
            color: Colors.grey[350],
          ),
          ListTile(
            leading: Icon(Icons.copyright),
            title: Text(S.of(context).homeDrawerLicenses),
            trailing: new Icon(Icons.keyboard_arrow_right),
            onTap: () => _showLicense(context),
          ),
        ],
      ),
    );
  }

  void _goToSettings(BuildContext context) {
    RouteNavigator.goPage(context, new SettingPage());
  }

  void _showLicense(BuildContext context) {
    PackageInfo.fromPlatform().then((packageInfo) {
      RouteNavigator.goPage(
        context,
        LicensePage(
          applicationName: packageInfo.appName,
          applicationVersion:
              'v ' + packageInfo.version + ' build' + packageInfo.buildNumber,
          applicationLegalese: S.of(context).copyrightLegalese,
        ),
      );
    }).catchError(() {
      RouteNavigator.goPage(
        context,
        LicensePage(
          applicationName: S.of(context).appName,
          applicationVersion: '',
          applicationLegalese: S.of(context).copyrightLegalese,
        ),
      );
    });
  }
}
