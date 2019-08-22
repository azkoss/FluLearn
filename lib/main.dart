import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/home/home_page.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/constant.dart';
import 'manager/app_manager.dart';
import 'manager/router_manager.dart';
import 'splash.dart';

void main() {
  runApp(new MyApp());

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.white30,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  }
}

class MyApp extends StatelessWidget {
  MyApp() {
    final router = Router();
    AppManager.router = router;
    RouteManager.configureRoutes(router);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Constant.primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Constant.enableSplash ? SplashPage() : HomePage(),
      onGenerateRoute: AppManager.router.generator,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        new FlutterI18nDelegate(
          // 语言代码参见 https://baike.baidu.com/item/ISO 639-1
          // 国家代码参见 https://baike.baidu.com/item/ISO 3166-1
          // 语言标记参见 http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry
          useCountryCode: true,
          fallbackFile: 'zh_Hans',
          path: 'assets/i18n',
        ),
      ],
      supportedLocales: [
        // Simple Chinese
        const Locale('zh', 'CN'),
        // American English
        const Locale('en', 'US')
      ],
    );
  }
}
