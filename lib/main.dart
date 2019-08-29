import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/constant.dart';
import 'package:flutter_app/empty/empty_router.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/home/home_page.dart';
import 'package:flutter_app/home/home_router.dart';
import 'package:flutter_app/splash/splash_page.dart';
import 'package:flutter_app/util/language.dart';
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

ValueChanged<Locale> localeChanged;

class MyApp extends StatelessWidget {
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
      home: LocalizationHome(),
      //生成页面路由（用于Router）
      onGenerateRoute: RouteNavigator.router.generator,
      //生成页面标题（用于AppBar）
      onGenerateTitle: (context) {
        return S
            .of(context)
            .textDirection
            .toString();
      },
      //区域设置，用于语言、日期时间、文字方向等本地化
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      localeResolutionCallback: S.delegate.resolution(
        fallback: Language.defaultLocale,
        withCountry: true,
      ),
    );
  }
}

class LocalizationHome extends StatefulWidget {
  @override
  _LocalizationHomeState createState() => _LocalizationHomeState();
}

class _LocalizationHomeState extends State<LocalizationHome> {
  Locale _locale = Language.defaultLocale;

  @override
  void initState() {
    super.initState();
    localeChanged = (locale) {
      setState(() {
        _locale = locale;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: _locale,
      child: Constant.splashSeconds > 1 ? SplashPage() : HomePage(),
    );
  }
}
