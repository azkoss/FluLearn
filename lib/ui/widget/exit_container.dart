import 'dart:io' as DartVM show exit;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/toolkit/android_bridge.dart';
import 'package:flutter_app/toolkit/repeat_checker.dart';
import 'package:flutter_app/toolkit/toaster.dart';

///
/// 按两次返回键可退出应用
///
class ExitContainer extends StatelessWidget {
  ExitContainer({
    @required this.child,
  }) : assert(child != null);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: child,
      onWillPop: () async {
        if (!RepeatChecker.isFastClick()) {
          Toaster.showLong(S.of(context).toastPressAgainToExit);
          return Future.value(false);
        }
        Toaster.cancel();
        await SystemNavigator.pop();
        DartVM.exit(0);
        await AndroidBridge.exitApp(true);
        return Future.value(true);
      },
    );
  }
}
