import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/constant.dart';
import 'package:flutter_app/config/prefs_key.dart';
import 'package:flutter_app/config/route_url.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/toolkit/image_loader.dart';
import 'package:flutter_app/toolkit/l.dart';
import 'package:flutter_app/ui/splash/splash_ad.dart';
import 'package:flutter_app/ui/widget/exit_container.dart';
import 'package:package_info/package_info.dart';

///
/// 闪屏页
///
class SplashPage extends StatefulWidget {
  const SplashPage({
    this.fetchAd = true,
  });

  final bool fetchAd;

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
    _obtainAppVersion();
    if (widget.fetchAd) {
      _obtainSplashImage();
      _updateSplashImage();
    }
    super.initState();
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

  void _obtainSplashImage() {
    setState(() {
      _imageUrl = SpUtil.getString(PrefsKey.splash_image_url, defValue: '');
      L.d("imageUrl=$_imageUrl");
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
        "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3095878455,1424909459&fm=26&gp=0.jpg";
    L.d("imageUrl=$imageUrl");
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
      child: SplashAd(
        backgroundColor: Colors.white,
        seconds: countdownSeconds,
        navigateTo: RouteUrl.home,
        imageUrl: noAd ? defaultImageUrl : _imageUrl,
        imagePlaceholder: defaultImageUrl,
        skipButtonText: noAd ? null : S.of(context).splashAdSkip,
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
