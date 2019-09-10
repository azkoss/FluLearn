import 'package:flutter/material.dart';
import 'package:flutter_app/util/image_loader.dart';
import 'package:flutter_app/widget/sliver_arc_panel.dart';

///
/// 登录页
///
class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverArcPanel(
      child: Container(
        alignment: Alignment.topCenter,
        child: ImageLoader.fromAsset('app_logo.png'),
      ),
    );
  }
}
