import 'package:flutter/services.dart';

///
/// Flutter与Android原生交互
///
class BridgeUtils {
  static const String CHANNEL_NAME = 'bridge';

  static void installApk(String path) {
    MethodChannel(CHANNEL_NAME).invokeMethod("installApk", {'path': path});
  }
}
