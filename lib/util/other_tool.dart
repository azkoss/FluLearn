import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_app/util/language.dart';
import 'package:flutter_app/util/toaster.dart';
import 'package:url_launcher/url_launcher.dart';

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

  ///
  /// 拨打电话
  ///
  static void callPhone(BuildContext context, String phone) async {
    String url = 'tel:' + phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Toaster.showShort(Language.translate(context, "toast.call_phone_failed"));
    }
  }
}
