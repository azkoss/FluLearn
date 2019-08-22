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
  /// 闪屏延时
  ///
  static const int splashSeconds = 4;

  ///
  /// 闪屏背景图
  ///
  static const String splashImage =
      "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=484070431,516280143&fm=26&gp=0.jpg";

  ///
  /// 标题栏高度
  ///
  static const double titleBarHeight = 48.0;

  ///
  /// 主色
  ///
  static const Color primaryColor = Color(0xFFF1F1F1);

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
