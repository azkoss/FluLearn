import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/config/constant.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/toolkit/theme_kit.dart';
import 'package:flutter_app/ui/empty/empty_router.dart';
import 'package:flutter_app/ui/guide/guide_router.dart';
import 'package:flutter_app/ui/home/home_page.dart';
import 'package:flutter_app/ui/home/home_router.dart';
import 'package:flutter_app/ui/login/login_router.dart';
import 'package:flutter_app/ui/splash/splash_page.dart';
import 'package:flutter_app/toolkit/l.dart';
import 'package:flutter_app/toolkit/language_kit.dart';
import 'package:flutter_app/toolkit/overlay_style.dart';
import 'package:flutter_app/toolkit/route_navigator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final GlobalKey<AppWrapperState> appStateKey = new GlobalKey<AppWrapperState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initAsync().then((v) {
    L.d('app init end');
    runApp(MyApp());
  });
}

Future<void> initAsync() async {
  L.d('app init start');
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
    return AppWrapper(key: appStateKey);
  }
}

class AppWrapper extends StatefulWidget {
  AppWrapper({Key key}) : super(key: key);

  @override
  AppWrapperState createState() => AppWrapperState();
}

class AppWrapperState extends State<AppWrapper> {
  Locale _locale;
  ThemeData _themeData;

  void changeLocale(Locale locale) {
    setState(() {
      L.d('change locale to $locale from $_locale');
      _locale = locale;
    });
  }

  void changeThemeData(ThemeData themeData) {
    setState(() {
      L.d('''change theme data
            to ${themeData.brightness} ${themeData.primaryColor}
            from ${_themeData.brightness} ${_themeData.primaryColor}''');
      _themeData = themeData;
    });
  }

  @override
  void initState() {
    super.initState();
    _locale = LanguageKit.locale;
    _themeData = ThemeKit.themeData;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //右上角调试标记
      debugShowCheckedModeBanner: true,
      //主题色彩
      theme: _themeData,
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
