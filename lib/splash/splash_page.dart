import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/constant.dart';
import 'package:flutter_app/common/prefs_key.dart';
import 'package:flutter_app/home/home_page.dart';
import 'package:flutter_app/util/image_loader.dart';
import 'package:flutter_app/util/language.dart';
import 'package:flutter_app/util/logger.dart';
import 'package:flutter_app/widget/exit_container.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

///
/// 闪屏页
///
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final defaultImageUrl = ImageLoader.assetPath("app_splash.webp");
  String _imageUrl;
  bool _imageLight;
  String _appName;
  String _version;
  String _buildNumber;

  @override
  void initState() {
    _imageUrl = defaultImageUrl;
    _imageLight = true;
    _obtainSplashImage();
    _obtainAppVersion();
    _updateSplashImage();
    super.initState();
  }

  void _obtainSplashImage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      _imageUrl = sp.getString(PrefsKey.splash_image_url);
      _imageLight = sp.getBool(PrefsKey.splash_image_light);
      L.d("imageUrl=$_imageUrl, imageLight=$_imageLight");
    });
  }

  void _obtainAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appName = packageInfo.appName;
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
      L.d("appName=$_appName,version=$_version, buildNumber=$_buildNumber");
    });
  }

  void _updateSplashImage() {
    Future.microtask(() => _fetchFromNetwork())
        .timeout(new Duration(seconds: 2))
        .catchError((e) {
      L.e("fetch splash image timeout", e);
    });
  }

  Future _fetchFromNetwork() async {
    // TODO: fetch from network
    String imageUrl =
        "https://via.placeholder.com/720x1080/0000DD/FFFFFF.webp?text=Splash+Screen";
    bool imageLight = false;
    L.d("imageUrl=$imageUrl, imageLight=$imageLight");
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(PrefsKey.splash_image_url, imageUrl);
    sp.setBool(PrefsKey.splash_image_light, imageLight);
  }

  @override
  Widget build(BuildContext context) {
    return ExitContainer(
      child: _buildSplashScreen(context),
    );
  }

  Widget _buildSplashScreen(BuildContext context) {
    return SplashScreen(
      seconds: Constant.splashSeconds,
      navigateAfterSeconds: new HomePage(),
      title: new Text(
        TextUtil.isEmpty(_appName)
            ? ""
            : "$_appName v$_version [$_buildNumber]",
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: _imageLight ? Colors.black87 : Theme
              .of(context)
              .primaryColor,
        ),
      ),
      imageBackground: ImageLoader.fromProvider(_imageUrl, () {
        setState(() {
          _imageUrl = defaultImageUrl;
          _imageLight = true;
        });
      }),
      backgroundColor: Colors.transparent,
      loaderColor:
      _imageLight ? Colors.black87 : Theme
          .of(context)
          .primaryColor,
      loadingText: Text(
        Language.translate(context, "copyright.statement"),
        style: new TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12.5,
          color: _imageLight ? Colors.black87 : Theme
              .of(context)
              .primaryColor,
        ),
      ),
    );
  }
}
