import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/prefs_key.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/toolkit/l.dart';

///
/// 本地化语言工具类
///
/// 语言代码参见 https://baike.baidu.com/item/ISO%20639-1
/// 区域脚本代码 https://github.com/unicode-org/cldr/blob/master/common/validity/script.xml
/// 国家或地区代码参见 https://baike.baidu.com/item/ISO%203166-1
///
class LanguageKit {
  static const List<String> SUPPORT_TAGS = ['', 'en_US', 'zh_CN'];
  static int _languageIndex = -1;

  static Locale get locale {
    //Localizations.localeOf(context)
    return toLocale(tag);
  }

  static String get tag {
    return SUPPORT_TAGS[tagIndex];
  }

  static int get tagIndex {
    if (_languageIndex != -1) {
      return _languageIndex;
    }
    _languageIndex = SpUtil.getInt(PrefsKey.language_tag_index, defValue: 0);
    return _languageIndex;
  }

  static String toFriendlyName(BuildContext context, int index) {
    switch (index) {
      case 1:
        return 'English';
      case 2:
        return '简体中文';
      default:
        return S.of(context).settingsAutoBySystem;
    }
  }

  ///
  /// 切换语言
  ///
  static void change({int tagIndex, String tag}) {
    if (tag == null) {
      tag = SUPPORT_TAGS[tagIndex];
    }
    Locale targetLocale = toLocale(tag);
    L.d('target locale is $targetLocale from tag $tag');
    appStateKey.currentState.changeLocale(targetLocale);
    SpUtil.putInt(PrefsKey.language_tag_index, tagIndex);
    _languageIndex = tagIndex;
  }

  ///
  /// 根据语言标签得到[Locale]对象
  ///
  /// [langTag] e.g. en, zh_CN, zh_Hans, zh_Hans_CN, zh-Hant-TW
  ///
  static Locale toLocale(String langTag) {
    if (langTag == null || langTag.trim().isEmpty) {
      //跟随系统
      return null;
    }
    if (langTag.indexOf('_') == -1 && langTag.indexOf('-') == -1) {
      return new Locale(langTag);
    }
    Locale locale;
    final List<String> codes = langTag.split(new RegExp(r'(_|-)'));
    if (codes.length == 2) {
      if (codes[1].length > 2) {
        locale = Locale.fromSubtags(
          languageCode: codes[0],
          scriptCode: codes[1],
        );
      } else {
        locale = Locale.fromSubtags(
          languageCode: codes[0],
          countryCode: codes[1],
        );
      }
    } else if (codes.length == 3) {
      locale = Locale.fromSubtags(
        languageCode: codes[0],
        scriptCode: codes[1],
        countryCode: codes[2],
      );
    } else {
      locale = new Locale(codes[0]);
    }
    return locale;
  }
}
