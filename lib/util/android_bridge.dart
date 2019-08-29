import 'package:flutter/services.dart';

///
/// Flutter与Android原生交互
///
class AndroidBridge {
  static const String CHANNEL_NAME = 'gzu-liyujiang/bridge';

  static void installApk(String path) {
    MethodChannel(CHANNEL_NAME).invokeMethod("installApk", {'path': path});
  }
}
