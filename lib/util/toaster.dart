import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
/// 吐司工具类
///
class Toaster {
  static showShort(String msg) {
    _show(msg, isShort: true);
  }

  static showLong(String msg) {
    _show(msg, isShort: false);
  }

  static _show(String msg, {isShort = true}) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.CENTER,
        fontSize: 16,
        textColor: Colors.white,
        backgroundColor: Colors.black54,
        toastLength: isShort ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
        timeInSecForIos: isShort ? 1 : 5);
  }

  static cancel() {
    Fluttertoast.cancel();
  }
}
