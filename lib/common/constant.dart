import 'dart:ui';

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
  /// 闪屏启用开关
  ///
  static const bool enableSplash = false;

  ///
  /// 标题栏高度
  ///
  static const double titleBarHeight = 48.0;

  ///
  /// 主色
  ///
  static const Color primaryColor = Color(0xFFF2F2F2);

  ///
  /// 路由协议头
  ///
  static const String urlScheme = "lyj://";

  ///
  /// 网页加载器代理串
  ///
  static const String userAgent =
      "Mozilla/5.0 (Linux; Android 7.0; PLUS Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.98 Mobile Safari/537.36";
}
