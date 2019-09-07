import 'package:flutter/services.dart';

///
/// Flutter与Android原生交互
///
class AndroidBridge {
  static const String CHANNEL_NAME = 'gzu-liyujiang/bridge';

  static Future<void> installApk(String path) async {
    var arguments = {'path': path};
    await MethodChannel(CHANNEL_NAME).invokeMethod("installApk", arguments);
  }

  static Future<void> exitApp(bool forceKill) async {
    var arguments = {'forceKill': forceKill};
    await MethodChannel(CHANNEL_NAME).invokeMethod("exitApp", arguments);
  }
}
