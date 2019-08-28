import 'package:flutter/cupertino.dart';
import 'package:flutter_app/common/application.dart';
import 'package:flutter_app/util/toast_utils.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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

  ///
  /// 切换语言
  ///
  static void changeLanguage(BuildContext context, String langTag) {
    //Future.delayed(Duration.zero, () {
    FlutterI18n.refresh(context, obtainLocale(langTag)).whenComplete(() {
      Locale currentLocale = FlutterI18n.currentLocale(context);
      Application.logger.d("currentLocale: $currentLocale");
    });
    //});
  }

  ///
  /// 根据语言标签得到[Locale]对象
  ///
  /// [langTag] e.g. zh, zh_CN, zh_Hans, zh_Hans_CN
  ///
  static Locale obtainLocale(String langTag) {
    Locale locale;
    if (langTag.indexOf("_") == -1) {
      locale = new Locale(langTag);
    } else {
      List<String> langTags = langTag.split("_");
      if (langTags.length == 2) {
        if (langTags[1].length > 2) {
          locale = Locale.fromSubtags(
            languageCode: langTags[0],
            scriptCode: langTags[1],
          );
        } else {
          locale = Locale.fromSubtags(
            languageCode: langTags[0],
            countryCode: langTags[1],
          );
        }
      } else if (langTags.length == 3) {
        locale = Locale.fromSubtags(
          languageCode: langTags[0],
          scriptCode: langTags[1],
          countryCode: langTags[2],
        );
      } else {
        locale = new Locale(langTags[0]);
      }
    }
    return locale;
  }
}
