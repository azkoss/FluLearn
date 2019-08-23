import 'package:flutter/material.dart';
import 'package:flutter_app/util/image_utils.dart';
import 'package:flutter_app/util/navigate_utils.dart';
import 'package:flutter_app/util/toast_utils.dart';

///
/// 主页抽屉
///
class HomeDrawer extends StatelessWidget {
  HomeDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _buildDrawer(context),
      elevation: 10.0,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Column(
      children: <Widget>[
//        ListView(
//          padding: EdgeInsets.zero,
//          shrinkWrap: true,
//          children: <Widget>[
//            _buildHeader(context),
//            _buildBody(context),
//          ],
//        ),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildHeader(context),
              _buildBody(context),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.grey[300],
          ),
        ),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          ClipOval(
            child: GestureDetector(
              onTap: () {
                ToastUtils.showShort("用户头像");
              },
              child: ImageUtils.fromNetwork(
                "https://avatars3.githubusercontent.com/u/16816717?s=460&v=4",
                width: 60,
                height: 60,
              ),
            ),
          ),
          Container(height: 10),
          Center(
            child: Text(
              "穿青人",
              style: TextStyle(),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(child: Text("网")),
          title: Text('网页浏览器'),
          onTap: () {
            return NavigateUtils.goWeb(context, "http://qqtheme.cn");
          },
        ),
        Divider(
          height: 1,
          color: Colors.grey[350],
        ),
        ListTile(
          leading: CircleAvatar(child: Text("404")),
          title: Text('Page Not Found'),
          subtitle: Text("Drawer item B subtitle"),
          onTap: () {
            return NavigateUtils.push(context, "/404");
          },
        ),
        Container(
          width: double.infinity,
          height: 10,
          color: Colors.grey[300],
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('设置'),
          trailing: new Icon(Icons.keyboard_arrow_right),
          onTap: () => _goToSettings(context),
        ),
        Divider(
          height: 1,
          color: Colors.grey[350],
        ),
        ListTile(
          leading: Icon(Icons.copyright),
          title: Text("Licenses"),
          trailing: new Icon(Icons.keyboard_arrow_right),
          onTap: () => _showLicense(context),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return SizedBox.shrink();
  }

  void _goToSettings(BuildContext context) {
    ToastUtils.showShort("设置");
  }

  void _showLicense(BuildContext context) {
    NavigateUtils.goPage(
        context,
        LicensePage(
          applicationVersion: "v1.0",
          applicationIcon: ImageUtils.fromAsset(
            "assets/image/app_logo.png",
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
          applicationLegalese: "本应用使用了第三方开源程序，许可协议详见如下。",
        ));
  }
}
