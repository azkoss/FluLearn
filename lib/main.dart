import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/constant.dart';
import 'package:flutter_app/empty/empty_router.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/home/home_page.dart';
import 'package:flutter_app/home/home_router.dart';
import 'package:flutter_app/splash/splash_page.dart';
import 'package:flutter_app/util/language.dart';
import 'package:flutter_app/util/logger.dart';
import 'package:flutter_app/util/other_tool.dart';
import 'package:flutter_app/util/route_navigator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  OtherTool.setUiOverlayStyle(Brightness.dark);
  RouteNavigator.registerRouter([
    new EmptyRouter(),
    new HomeRouter(),
  ]);
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

//参阅《Flutter-国际化适配终结者》 https://www.jianshu.com/p/b9f830efe1f8
ValueChanged<Locale> localeChanged;

class _MyAppState extends State<MyApp> {
  Locale _locale = Language.defaultLocale;

  @override
  void initState() {
    super.initState();
    localeChanged = (locale) {
      setState(() {
        _locale = locale;
        Locale currentLocale = Localizations.localeOf(context);
        L.d("locale changed: $locale, current locale is $currentLocale");
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //右上角调试标记
      debugShowCheckedModeBanner: true,
      //界面风格
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFFF2F2F2),
        scaffoldBackgroundColor: Colors.white,
      ),
      //主入口页面
      home: Constant.splashSeconds > 1 ? SplashPage() : HomePage(),
      //生成页面路由（用于Router）
      onGenerateRoute: RouteNavigator.router.generator,
      //生成页面标题（用于AppBar）
      onGenerateTitle: (context) {
        return S
            .of(context)
            .appName;
      },
      //区域设置，用于语言、日期时间、文字方向等本地化
      locale: _locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
    );
  }
}
