import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:package_info/package_info.dart';
import 'package:splashscreen/splashscreen.dart';

import '../home/home_page.dart';
import '../util/image_utils.dart';
import '../widget/exit_container.dart';

///
/// 闪屏页
///
class SplashPage extends StatefulWidget {
  SplashPage({this.seconds = 5, this.imageUrl = ""});

  final int seconds;
  final String imageUrl;

  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String _appName;
  String _version;
  String _buildNumber;

  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _appName = packageInfo.appName;
        _version = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExitContainer(
      child: SplashScreen(
        seconds: widget.seconds,
        navigateAfterSeconds: new HomePage(),
        title: new Text(
          FlutterI18n.translate(context, "splash.welcome_title",
              Map.fromIterables(["user"], ["liyujiang"])),
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        imageBackground: ImageUtils.fromProvider(widget.imageUrl),
        backgroundColor: Colors.white,
        loaderColor: Theme.of(context).primaryColor,
        loadingText: Text(
          TextUtil.isEmpty(_appName)
              ? FlutterI18n.translate(context, "splash.welcome_loading")
              : "$_appName v$_version [$_buildNumber]",
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
