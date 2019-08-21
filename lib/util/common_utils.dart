import 'package:url_launcher/url_launcher.dart';

import '../util/toast_utils.dart';

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
