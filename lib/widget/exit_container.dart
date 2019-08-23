import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/util/repeat_utils.dart';
import 'package:flutter_app/util/toast_utils.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

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
        if (!RepeatUtils.isFastClick()) {
          ToastUtils.showLong(
              FlutterI18n.translate(context, "exit.double_click_tip"));
          return Future.value(false);
        }
        ToastUtils.cancel();
        await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return Future.value(true);
      },
    );
  }
}
