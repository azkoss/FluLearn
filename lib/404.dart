import 'package:flutter/material.dart';
import 'package:flutter_app/widget/app_bar.dart';
import 'package:flutter_app/widget/state_layout.dart';

///
/// 路由跳转错误提示页
///
class WidgetNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LyjAppBar(
        centerTitle: "页面不存在",
      ),
      body: const LyjStateLayout(
        type: StateType.error,
        hintText: "页面不存在",
      ),
    );
  }
}
