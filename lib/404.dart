import 'package:flutter/material.dart';
import 'package:flutter_app/widget/state_layout.dart';
import 'package:flutter_app/widget/title_bar.dart';

///
/// 路由跳转错误提示页
///
class PageNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LyjTitleBar(
        title: "页面不存在",
      ),
      body: const LyjStateLayout(
        type: StateType.error,
        hintText: "页面不存在",
      ),
    );
  }
}
