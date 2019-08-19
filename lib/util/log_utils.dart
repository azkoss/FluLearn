import 'package:common_utils/common_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../config/constant.dart';

///
/// 调试日志打印工具类
///
class LogUtils {
  static const perform = const MethodChannel("x_log");

  static d(String msg, {tag: 'X-LOG'}) {
    if (Constant.isDebug) {
      perform.invokeMethod('logD', {'tag': tag, 'msg': msg});
      _print(msg, tag: tag);
    }
  }

  static e(String msg, {tag: 'X-LOG'}) {
    if (Constant.isDebug) {
      perform.invokeMethod('logE', {'tag': tag, 'msg': msg});
      _print(msg, tag: tag);
    }
  }

  static _print(String msg, {tag: 'X-LOG'}) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      LogUtil.debuggable = Constant.isDebug;
      LogUtil.v(msg, tag: tag);
    }
  }
}
