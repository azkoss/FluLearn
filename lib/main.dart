import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/config/constant.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/page/empty/empty_router.dart';
import 'package:flutter_app/page/guide/guide_router.dart';
import 'package:flutter_app/page/home/home_page.dart';
import 'package:flutter_app/page/home/home_router.dart';
import 'package:flutter_app/page/login/login_router.dart';
import 'package:flutter_app/page/splash_page.dart';
import 'package:flutter_app/util/language.dart';
import 'package:flutter_app/util/logger.dart';
import 'package:flutter_app/util/overlay_style.dart';
import 'package:flutter_app/util/route_navigator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final GlobalKey<LocalizationAppState> localizationStateKey =
    new GlobalKey<LocalizationAppState>();

void main() {
  initAsync().then((v) {
    runApp(new MyApp());
  });
}

Future<void> initAsync() async {
  WidgetsFlutterBinding.ensureInitialized();
  OverlayStyle.setOverlayStyle(Brightness.dark);
  RouteNavigator.registerRouter([
    new EmptyRouter(),
    new GuideRouter(),
    new HomeRouter(),
    new LoginRouter(),
  ]);
  await SpUtil.getInstance();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocalizationApp(key: localizationStateKey);
  }
}

class LocalizationApp extends StatefulWidget {
  LocalizationApp({Key key}) : super(key: key);

  @override
  LocalizationAppState createState() {
    return LocalizationAppState();
  }
}

class LocalizationAppState extends State<LocalizationApp> {
  Locale _locale;

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
      L.d("change locale to: $locale");
    });
  }

  @override
  void initState() {
    super.initState();
    _locale = Language.currentLocaleFromSp();
    L.d("current locale is: $_locale");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //右上角调试标记
      debugShowCheckedModeBanner: true,
      //界面风格
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green,
        primaryColorDark: Colors.green,
        primaryColorLight: Colors.lightGreen,
        accentColor: Colors.green[900],
        backgroundColor: Color(0xFFF2F2F2),
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.lightGreen,
        dividerTheme: DividerThemeData(
          color: Colors.grey[350],
          space: 0.8,
        ),
        cursorColor: Colors.green[900],
      ),
      //主入口页面
      home: Constant.splashSeconds > 1 ? SplashPage() : HomePage(),
      //生成页面路由（用于Router）
      onGenerateRoute: RouteNavigator.router.generator,
      //生成页面标题（用于AppBar）
      onGenerateTitle: (context) {
        return S.of(context).appName;
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
