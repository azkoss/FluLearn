import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/constant.dart';
import 'package:flutter_app/config/prefs_key.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/util/image_loader.dart';
import 'package:flutter_app/util/logger.dart';
import 'package:flutter_app/widget/exit_container.dart';
import 'package:flutter_app/widget/splash_screen.dart';
import 'package:package_info/package_info.dart';

import 'home/home_router.dart';

///
/// 闪屏页
///
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final defaultImageUrl = ImageLoader.assetPath("app_splash.webp");
  String _imageUrl = '';
  String _appName;
  String _version;
  String _buildNumber;

  @override
  void initState() {
    _obtainSplashImage();
    _obtainAppVersion();
    _updateSplashImage();
    super.initState();
  }

  void _obtainSplashImage() async {
    await SpUtil.getInstance();
    setState(() {
      _imageUrl = SpUtil.getString(PrefsKey.splash_image_url, defValue: '');
      L.d("imageUrl=$_imageUrl");
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
        .timeout(new Duration(seconds: Constant.splashSeconds))
        .catchError((e) {
      L.e("fetch splash image timeout", e);
    });
  }

  Future _fetchFromNetwork() async {
    // TODO: fetch from network
    String imageUrl =
        "https://via.placeholder.com/720x1080/FF0000/0000DD.webp?text=Splash+Screen";
    L.d("imageUrl=$imageUrl");
    await SpUtil.getInstance();
    SpUtil.putString(PrefsKey.splash_image_url, imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final countdownSeconds = Constant.splashSeconds;
    final bool noAd = TextUtil.isEmpty(_imageUrl);
    String bottomText = S.of(context).copyrightStatement;
    if (!TextUtil.isEmpty(_appName)) {
      bottomText = "$_appName v$_version build$_buildNumber\n$bottomText";
    }
    return ExitContainer(
      child: SplashScreen(
        seconds: countdownSeconds,
        navigateTo: HomeRouter.homePage,
        imageUrl: noAd ? defaultImageUrl : _imageUrl,
        skipButtonText: noAd ? null : '跳过',
        bottomText: Text(
          bottomText,
          textAlign: TextAlign.center,
          style: new TextStyle(
            fontSize: 10.0,
            color: Colors.black87,
          ),
        ),
        onTickEvent: (seconds) {
          if (noAd && seconds == countdownSeconds - 1) {
            //若无广告图，则只无需展示那么多秒
            return true;
          }
          return false;
        },
      ),
    );
  }
}
