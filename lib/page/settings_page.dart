import 'package:flutter/material.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/page/about/change_log_page.dart';
import 'package:flutter_app/util/route_navigator.dart';
import 'package:flutter_app/widget/title_bar.dart';

///
/// 设置页
///
class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar(
        title: S.of(context).homeDrawerSettings,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text('语言'), Text('xx')],
              ),
              leading: Icon(Icons.public),
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      value: index,
                      onChanged: (index) {},
                      groupValue: 1,
                      title: Text('xxx'),
                    );
                  },
                )
              ],
            ),
            ListTile(
              title: Text('主题'),
              leading: Icon(Icons.color_lens),
              trailing: Icon(Icons.chevron_right),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text('更新日志'),
              onTap: () {
                RouteNavigator.goPage(context, new ChangeLogPage(),
                    fullscreenDialog: true);
              },
              leading: Icon(Icons.assignment),
              trailing: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
