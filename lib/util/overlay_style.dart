import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// 遮罩风格工具类
///
class OverlayStyle {
  ///
  /// 设置安卓系统状态栏及导航栏风格
  ///
  static void setOverlayStyle(Brightness brightness) {
    if (!Platform.isAndroid) {
      return;
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ));
  }

  static SystemUiOverlayStyle estimateOverlayStyle(Color behindColor) {
    return ThemeData.estimateBrightnessForColor(behindColor) == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
  }

  static Color estimateFrontColor(Color behindColor) {
    return estimateOverlayStyle(behindColor) == SystemUiOverlayStyle.light
        ? Colors.white
        : Color(0xFF333333);
  }
}
