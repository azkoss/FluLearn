import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/repeat_utils.dart';
import '../util/toast_utils.dart';

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
      onWillPop: _exitApp,
    );
  }

  Future<bool> _exitApp() async {
    if (!RepeatUtils.isFastClick()) {
      ToastUtils.showLong('再按一次退出应用');
      return Future.value(false);
    }
    ToastUtils.cancel();
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }
}
