import 'package:flustars/flustars.dart';
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/toolkit/toaster.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

///
/// 其他常用的辅助方法
///
class Universal {
  ///
  /// 拨打电话
  ///
  static Future<bool> callPhone(BuildContext context, String phone) async {
    return tryOpenUrl('tel:' + phone, S.of(context).toastCallPhoneFailed);
  }

  ///
  /// 打开特殊Scheme的Url，如：mailto:、tel:、mqqapi://、weixin://、iosamap://
  ///
  static Future<bool> tryOpenUrl(String url, [String failedMsg = '']) async {
    if (await UrlLauncher.canLaunch(url)) {
      return await UrlLauncher.launch(url);
    }
    if ('' != failedMsg) {
      Toaster.showShort(failedMsg);
    }
    return false;
  }

  ///
  /// 当前年份
  ///
  static String get currentYear {
    return DateUtil.formatDate(DateTime.now(), format: 'yyyy');
  }
}
