import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/util/language.dart';
import 'package:flutter_app/util/repeat_checker.dart';
import 'package:flutter_app/util/toaster.dart';

///
/// 按两次返回键可退出应用
///
class ExitContainer extends StatelessWidget {
  ExitContainer({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Material(
        child: child,
      ),
      onWillPop: () async {
        if (!RepeatChecker.isFastClick()) {
          Toaster.showLong(
              Language.translate(context, "toast.press_again_to_exit"));
          return Future.value(false);
        }
        Toaster.cancel();
        await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return Future.value(true);
      },
    );
  }
}
