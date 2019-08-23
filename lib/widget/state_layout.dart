import 'package:flutter/cupertino.dart';

///
/// 无网络\无数据\出错等空页面
/// Adapted from https://github.com/simplezhli/flutter_deer/.../state_layout.dart
///
class StateLayout extends StatefulWidget {
  const StateLayout(
      {Key key, @required this.type, this.hintImage, this.hintText})
      : super(key: key);

  final StateType type;
  final String hintImage;
  final String hintText;

  @override
  _StateLayoutState createState() => _StateLayoutState();
}

class _StateLayoutState extends State<StateLayout> {
  String _hintImage;
  String _hintText;

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case StateType.network:
        _hintImage = "state_no_network.png";
        _hintText = "无网络连接";
        break;
      case StateType.loading:
        _hintImage = "";
        _hintText = "";
        break;
      case StateType.error:
        _hintImage = "state_error.png";
        _hintText = "出错了";
        break;
      case StateType.empty:
        _hintImage = "";
        _hintText = "";
        break;
    }
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.type == StateType.loading
              ? CupertinoActivityIndicator(radius: 16.0)
              : (widget.type == StateType.empty
                  ? SizedBox()
                  : Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/image/$_hintImage"),
                        ),
                      ),
                    )),
          const SizedBox(width: 16),
          Text(
            widget.hintText ?? _hintText,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

enum StateType {
  /// 无网络
  network,

  /// 加载中
  loading,

  /// 出错
  error,

  /// 空
  empty
}
