import 'package:flutter/material.dart';
import 'package:flutter_app/widget/state_layout.dart';
import 'package:flutter_app/widget/title_bar.dart';

///
/// 路由跳转错误提示页
/// Adapted from https://github.com/simplezhli/flutter_deer/.../404.dart
///
class PageNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar(
        title: "页面不存在",
      ),
      body: const StateLayout(
        type: StateType.error,
        hintText: "页面不存在",
      ),
    );
  }
}
