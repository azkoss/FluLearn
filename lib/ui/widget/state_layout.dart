import 'package:flutter/material.dart';
import 'package:flutter_app/toolkit/image_loader.dart';

///
/// 无网络\无数据\出错等空页面
/// Adapted from https://github.com/simplezhli/flutter_deer/.../state_layout.dart
///
class StateLayout extends StatefulWidget {
  const StateLayout({Key key, this.type, this.hintImage, this.hintText})
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
      case StateType.error:
        _hintImage = "state_error.png";
        _hintText = "出错了";
        break;
      case StateType.no_data:
        _hintImage = "state_no_data.png";
        _hintText = "";
        break;
      default:
        _hintImage = "";
        _hintText = "";
        break;
    }
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildIndicator(context),
          const SizedBox(width: 16),
          _buildText(context),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildIndicator(BuildContext context) {
    if (widget.type == StateType.loading) {
      return CircularProgressIndicator();
    }
    if (widget.type == StateType.blank) {
      return SizedBox();
    }
    return Container(
      height: 80.0,
      width: 80.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ImageLoader.fromProvider(widget.hintImage ?? _hintImage),
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    return Text(
      widget.hintText ?? _hintText,
      style: TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }
}

enum StateType {
  /// 加载中
  loading,

  /// 无网络
  network,

  /// 出错
  error,

  /// 无数据
  no_data,

  /// 空白
  blank
}
