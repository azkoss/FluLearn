import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/application.dart';
import 'package:flutter_app/common/prefs_key.dart';
import 'package:flutter_app/home/home_page.dart';
import 'package:flutter_app/util/image_utils.dart';
import 'package:flutter_app/util/prefs_utils.dart';
import 'package:flutter_app/widget/exit_container.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:package_info/package_info.dart';
import 'package:splashscreen/splashscreen.dart';

///
/// 闪屏页
///
class SplashPage extends StatefulWidget {
  final int defaultSeconds = 5;
  final defaultImageUrl = "assets/image/app_splash.webp";

  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String _imageUrl;
  bool _imageLight;
  String _appName;
  String _version;
  String _buildNumber;

  @override
  void initState() {
    _imageUrl = widget.defaultImageUrl;
    _imageLight = true;
    Future.microtask(() => PrefsUtils.getInstance())
        .then((result) => _obtainSplashImage(result));
    _obtainAppVersion();
    _updateSplashImage();
    super.initState();
  }

  _obtainSplashImage(PrefsUtils prefsUtils) {
    setState(() {
      _imageUrl = PrefsUtils.getString(PrefsKey.splash_image_url);
      _imageLight = PrefsUtils.getBool(PrefsKey.splash_image_light);
      Application.logger.d("imageUrl=$_imageUrl, imageLight=$_imageLight");
    });
  }

  void _obtainAppVersion() {
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        _appName = packageInfo.appName;
        _version = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
        Application.logger.d(
            "appName=$_appName,version=$_version, buildNumber=$_buildNumber");
      });
    });
  }

  void _updateSplashImage() {
    Future.microtask(() => _fetchFromNetwork())
        .timeout(new Duration(seconds: 2))
        .catchError((e) {
      Application.logger.e("fetch splash image timeout", e);
    });
  }

  Future _fetchFromNetwork() async {
    // TODO: fetch from network
    String imageUrl =
        "https://via.placeholder.com/720x1080/0000DD/FFFFFF.webp?text=Splash+Screen";
    bool imageLight = false;
    Application.logger.d("imageUrl=$imageUrl, imageLight=$imageLight");
    PrefsUtils.putString(PrefsKey.splash_image_url, imageUrl);
    PrefsUtils.putBool(PrefsKey.splash_image_light, imageLight);
  }

  @override
  Widget build(BuildContext context) {
    return ExitContainer(
      child: _buildSplashScreen(context),
    );
  }

  Widget _buildSplashScreen(BuildContext context) {
    return SplashScreen(
      seconds: widget.defaultSeconds,
      navigateAfterSeconds: new HomePage(),
      title: new Text(
        FlutterI18n.translate(context, "splash.welcome_title",
            Map.fromIterables(["user"], ["liyujiang"])),
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: _imageLight ? Colors.black87 : Theme
              .of(context)
              .primaryColor,
        ),
      ),
      imageBackground: ImageUtils.fromProvider(_imageUrl, () {
        setState(() {
          _imageUrl = widget.defaultImageUrl;
          _imageLight = true;
        });
      }),
      backgroundColor: Colors.transparent,
      loaderColor:
      _imageLight ? Colors.black87 : Theme
          .of(context)
          .primaryColor,
      loadingText: Text(
        TextUtil.isEmpty(_appName)
            ? FlutterI18n.translate(context, "splash.welcome_loading")
            : "$_appName v$_version [$_buildNumber]",
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: _imageLight ? Colors.black87 : Theme
              .of(context)
              .primaryColor,
        ),
      ),
    );
  }
}
