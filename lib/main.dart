import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/application.dart';
import 'package:flutter_app/common/constant.dart';
import 'package:flutter_app/common/routers.dart';
import 'package:flutter_app/home/home_page.dart';
import 'package:flutter_app/splash/splash_page.dart';
import 'package:flutter_app/util/common_utils.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final router = Router();
  Application.router = router;
  Routers.configure(router);

  // 注意可能启动黑屏问题，参见 https://github.com/ilteoood/flutter_i18n/issues/17
  FlutterI18nDelegate delegate = FlutterI18nDelegate(
    useCountryCode: true,
    // 语言标记参见 http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry
    fallbackFile: Constant.languageTag,
    path: Constant.languageDir,
  );
  delegate
      .load(CommonUtils.obtainLocale(Constant.languageTag))
      .whenComplete(() {
    runApp(new MainApp(delegate));
  });

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

class MainApp extends StatelessWidget {
  MainApp(this.languageLocalizationsDelegate);

  final FlutterI18nDelegate languageLocalizationsDelegate;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: new ThemeData(
        primaryColor: Constant.primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Constant.enableSplash ? SplashPage() : HomePage(),
      onGenerateRoute: Application.router.generator,
      localizationsDelegates: [
        languageLocalizationsDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        // 语言代码参见 https://baike.baidu.com/item/ISO 639-1
        // 国家代码参见 https://baike.baidu.com/item/ISO 3166-1
        new Locale("zh", 'CN'),
        new Locale("zh", 'TW'),
        new Locale('en', 'US'),
      ],
    );
  }
}
