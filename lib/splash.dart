import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'home/home_page.dart';
import 'util/log_utils.dart';

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
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new HomePage(),
        title: new Text(
          'Welcome In SplashScreen',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        imageBackground: new NetworkImage(
            'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=484070431,516280143&fm=26&gp=0.jpg'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () {
          LogUtils.d("点击闪屏图片");
        },
        loaderColor: Colors.blue);
  }
}
