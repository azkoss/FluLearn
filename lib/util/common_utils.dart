import 'package:flutter_app/util/toast_utils.dart';
import 'package:url_launcher/url_launcher.dart';

///
/// 基础工具类
///
class CommonUtils {
  ///
  /// 拨打电话
  ///
  static void callPhone(String phone) async {
    String url = 'tel:' + phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ToastUtils.showShort('拨号失败！');
    }
  }

}
