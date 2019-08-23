import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/application.dart';
import 'package:flutter_app/common/constant.dart';
import 'package:flutter_app/common/routers.dart';
import 'package:flutter_app/home/home_page.dart';
import 'package:flutter_app/splash/splash_page.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future main() async {
  // 语言代码参见 https://baike.baidu.com/item/ISO 639-1
  // 国家代码参见 https://baike.baidu.com/item/ISO 3166-1
  final Locale chinese = new Locale('zh', 'CN');
  final Locale english = new Locale('en', 'US');

  final router = Router();
  Application.router = router;
  Routers.configure(router);

  //FlutterI18n+SplashScreen启动黑屏问题，参见 https://github.com/ilteoood/flutter_i18n/issues/17
  final FlutterI18nDelegate flutterI18nDelegate = new FlutterI18nDelegate(
    useCountryCode: true,
    // 语言标记参见 http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry
    fallbackFile: 'zh_Hans',
    path: 'assets/i18n',
  );
  await flutterI18nDelegate.load(chinese);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: true,
    theme: new ThemeData(
      primaryColor: Constant.primaryColor,
      scaffoldBackgroundColor: Colors.white,
    ),
    home: Constant.enableSplash ? SplashPage() : HomePage(),
    onGenerateRoute: Application.router.generator,
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      flutterI18nDelegate,
    ],
    supportedLocales: [chinese, english],
  ));

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  }
}
