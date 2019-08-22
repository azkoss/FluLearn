import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:splashscreen/splashscreen.dart';

import 'config/constant.dart';
import 'home/home_page.dart';
import 'util/image_utils.dart';
import 'widget/exit_container.dart';

///
/// 闪屏页
///
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return ExitContainer(
      child: SplashScreen(
        seconds: Constant.splashSeconds,
        navigateAfterSeconds: new HomePage(),
        title: new Text(
          FlutterI18n.translate(context, "splash.welcome_title",
              Map.fromIterables(["user"], ["liyujiang"])),
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        imageBackground: ImageUtils.fromProvider(
            'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=484070431,516280143&fm=26&gp=0.jpg'),
        backgroundColor: Colors.white,
        loaderColor: Theme
            .of(context)
            .primaryColor,
        loadingText: Text(
          FlutterI18n.translate(context, "splash.welcome_loading"),
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Theme
                .of(context)
                .primaryColor,
          ),
        ),
      ),
    );
  }
}
