///
/// 网络响应数据
/// Adapted from https://github.com/simplezhli/flutter_deer/.../base_entity.dart
///
class BaseResp<T> {
  int code;
  String message;
  T data;

  BaseResp(this.code, this.message, this.data);
}
