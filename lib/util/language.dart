import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/util/logger.dart';

///
/// 本地化语言工具类
///
class Language {
  ///
  /// 切换语言
  ///
  static void change(BuildContext context, String langTag) {
    Locale switchLocale = toLocale(langTag);
    L.d("switch locale is $switchLocale from tag $langTag");
    localizationStateKey.currentState.changeLocale(switchLocale);
  }

  ///
  /// 根据语言标签得到[Locale]对象
  ///
  /// [langTag] e.g. zh, zh_CN, zh_Hans, zh_Hans_CN, zh-Hans-CN
  ///
  static Locale toLocale(String langTag) {
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
