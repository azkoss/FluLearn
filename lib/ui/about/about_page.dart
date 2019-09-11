import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/toolkit/image_loader.dart';
import 'package:flutter_app/toolkit/route_navigator.dart';
import 'package:flutter_app/ui/about/change_log_page.dart';
import 'package:flutter_app/ui/about/licenses_page.dart';
import 'package:flutter_app/ui/widget/back_screen.dart';
import 'package:package_info/package_info.dart';

///
/// 关于页
///
class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPage> {
  String _version;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((pi) {
      setState(() {
        _version = 'v' + pi.version + ' build' + pi.buildNumber;
      });
    });
  }

  Widget build(BuildContext context) {
    return BackScreen(
      intrinsicHeight: true,
      title: S.of(context).titleAbout,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: 30,
          ),
          Center(
            child: ImageLoader.fromAsset(
              'app_logo.png',
              width: 80,
              height: 80,
            ),
          ),
          TextUtil.isEmpty(_version)
              ? SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    _version,
                    textAlign: TextAlign.center,
                  ),
                ),
          SizedBox(
            width: double.infinity,
            height: 30,
          ),
          _buildBody(context),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10, top: 15),
                child: Text(
                  S.of(context).copyrightStatement,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Divider(),
          ListTile(
            title: Text(S.of(context).titleChangeLog),
            onTap: () {
              RouteNavigator.goPage(context, new ChangeLogPage());
            },
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            title: Text(S.of(context).titleWebSite),
            trailing: new Icon(Icons.chevron_right),
            onTap: () {
              return RouteNavigator.goWeb(context, 'http://qqtheme.cn');
            },
          ),
          Divider(),
          ListTile(
            title: Text(S.of(context).titleLicenses),
            trailing: new Icon(Icons.chevron_right),
            onTap: () {
              return RouteNavigator.goPage(
                context,
                LicensesPage(
                  legalese: S.of(context).copyrightLegalese,
                ),
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
