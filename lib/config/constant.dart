import 'dart:ui' show Locale;

///
/// 常量集中管理
///
class Constant {
  ///
  /// 调试开关，上线需要关闭
  /// 运行在Release环境时为true；运行在Debug和Profile环境时为false
  ///
  static const bool enableDebug =
  !const bool.fromEnvironment("dart.vm.product");

  ///
  /// 闪屏时长，大于1秒才显示闪屏页
  ///
  static const int splashSeconds = 5;

  ///
  /// 标题栏高度
  ///
  static const double titleBarHeight = 48.0;

  ///
  /// 路由协议头
  ///
  static const String urlScheme = "lyj://";

  ///
  /// 默认区域设置（语言代码-区域脚本代码-国家或地区代码）
  ///
  /// 语言代码参见 https://baike.baidu.com/item/ISO%20639-1
  /// 区域脚本代码 https://github.com/unicode-org/cldr/blob/master/common/validity/script.xml
  /// 国家或地区代码参见 https://baike.baidu.com/item/ISO%203166-1
  ///
  static const Locale defaultLocale = const Locale.fromSubtags(
      languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN');
}
