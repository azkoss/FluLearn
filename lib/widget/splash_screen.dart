import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_app/config/constant.dart';

///
/// 闪屏，参阅 https://github.com/KarimMohamed2005/SplashScreenFlutterPackage
///
class SplashScreen extends StatefulWidget {
  final int seconds;
  final dynamic navigateTo;
  final Color backgroundColor;
  final RaisedButton skipButton;
  final ImageProvider image;
  final Text loadingText;
  final Color loaderColor;
  final dynamic onClick;

  SplashScreen({
    @required this.seconds,
    this.navigateTo,
    this.backgroundColor = Colors.green,
    this.skipButton,
    this.image,
    this.loadingText = const Text(''),
    this.loaderColor,
    this.onClick,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
//    Timer(Duration(seconds: widget.seconds), () {
//      if (widget.navigateTo is String) {
//        // It's fairly safe to assume this is using the in-built material
//        // named route component
//        RouteNavigator.goPath(context, widget.navigateTo);
//      } else if (widget.navigateTo is Widget) {
//        RouteNavigator.goPage(context, widget.navigateTo);
//      } else {
//        throw new ArgumentError('navigateTo must either be a String or Widget');
//      }
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: widget.backgroundColor,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: widget.onClick,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.image,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: Constant.titleBarHeight),
                      ),
                      widget.skipButton == null
                          ? SizedBox()
                          : Align(
                              alignment: Alignment.topRight,
                              child: widget.skipButton,
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.only(top: 10.0),
//            ),
//            Center(
//              child: SizedBox(
//                width: 25,
//                height: 25,
//                child: CircularProgressIndicator(
//                  valueColor:
//                      new AlwaysStoppedAnimation<Color>(widget.loaderColor),
//                ),
//              ),
//            ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
                widget.loadingText,
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
