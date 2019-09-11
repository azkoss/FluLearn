import 'package:flutter/material.dart';
import 'package:flutter_app/ui/widget/back_screen.dart';
import 'package:flutter_app/ui/widget/state_layout.dart';

///
/// 空页提示
/// Adapted from https://github.com/simplezhli/flutter_deer/.../404.dart
///
class EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackScreen(
      intrinsicHeight: true,
      title: '页面不存在',
      body: StateLayout(
        type: StateType.error,
        hintText: '页面不存在',
      ),
    );
  }
}
