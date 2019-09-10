import 'package:flutter_app/util/logger.dart';

///
/// 重复操作、快速点击
///
class RepeatChecker {
  static DateTime _lastTime;

  static bool isFastClick() {
    return isDoubleAction(1500);
  }

  static bool isDoubleAction(int diffMs) {
    if (_lastTime == null ||
        DateTime.now().difference(_lastTime) > Duration(milliseconds: diffMs)) {
      _lastTime = DateTime.now();
      return false;
    }
    L.d("is fast double action: duration=$diffMs");
    return true;
  }
}
