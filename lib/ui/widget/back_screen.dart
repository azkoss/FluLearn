import 'package:flutter/material.dart';
import 'package:flutter_app/ui/widget/title_bar.dart';

///
/// 返回屏
///
class BackScreen extends StatelessWidget {
  BackScreen({
    this.title = '',
    this.action,
    this.presetScroll = true,
    this.intrinsicHeight = false,
    this.physics = const BouncingScrollPhysics(),
    @required this.body,
  });

  final String title;
  final Widget action;
  final bool presetScroll;
  final bool intrinsicHeight;
  final ScrollPhysics physics;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar(
        title: title,
        action: action,
      ),
      body: presetScroll ? _buildScroll() : body,
    );
  }

  /// The body becomes either as big as viewport, or as big as
  /// the contents, whichever is biggest.
  ///
  ///参见[SingleChildScrollView]源码自带的示例。
  Widget _buildScroll() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          physics: physics,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: intrinsicHeight ? IntrinsicHeight(child: body) : body,
          ),
        );
      },
    );
  }
}
