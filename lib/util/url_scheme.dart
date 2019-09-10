import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/util/toaster.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

///
/// UrlScheme工具类
///
class UrlScheme {
  ///
  /// 拨打电话
  ///
  static Future<bool> callPhone(BuildContext context, String phone) async {
    return tryOpen('tel:' + phone, S.of(context).toastCallPhoneFailed);
  }

  ///
  /// 打开特殊Scheme的Url，如：mailto:、tel:、mqqapi://、weixin://、iosamap://
  ///
  static Future<bool> tryOpen(String url, [String failedMsg = '']) async {
    if (await UrlLauncher.canLaunch(url)) {
      return await UrlLauncher.launch(url);
    }
    if ('' != failedMsg) {
      Toaster.showShort(failedMsg);
    }
    return false;
  }
}
