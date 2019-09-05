import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// 额外的工具类
///
class OtherTool {
  ///
  /// 设置安卓系统状态栏及导航栏风格
  ///
  static void setUiOverlayStyle(Brightness brightness) {
    if (!Platform.isAndroid) {
      return;
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: brightness,
    ));
  }
}
