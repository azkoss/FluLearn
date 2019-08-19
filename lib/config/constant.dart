///
/// 常量集中管理
///
class Constant {
  /// 调试开关，上线需要关闭
  /// 运行在Release环境时为true；运行在Debug和Profile环境时为false
  static const bool isDebug = !const bool.fromEnvironment("dart.vm.product");
}
