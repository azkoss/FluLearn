///
/// 常量集中管理
///
class Constant {
  ///
  /// 调试开关，上线需要关闭
  /// 运行在Release环境时为true；运行在Debug和Profile环境时为false
  ///
  static const bool isDebug = !const bool.fromEnvironment("dart.vm.product");

  ///
  /// 路由协议头
  ///
  static const String scheme = "lyj://";

  ///
  /// 网页加载器代理串
  ///
  static const String userAgent =
      "Mozilla/5.0 (Linux; Android 7.0; PLUS Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.98 Mobile Safari/537.36";
}
