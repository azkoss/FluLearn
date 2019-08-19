import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: true,
    theme: new ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
    ),
    home: new SplashPage(),
  ));

  if (Platform.isAndroid) {
    //设置状态栏完全透明，默认是半透明的
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
}
