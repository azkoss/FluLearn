import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformAssetBundle;
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/widget/title_bar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

const _ASSET_PATH = 'res/CHANGELOG.md';

///
/// 版本更新日志页
///
class ChangeLogPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar(
        title: S.of(context).titleChangeLog,
      ),
      body: ChangeLog(),
    );
  }
}

class ChangeLog extends StatefulWidget {
  @override
  _ChangeLogState createState() => _ChangeLogState();
}

class _ChangeLogState extends State<ChangeLog> {
  String _data;

  @override
  void initState() {
    super.initState();
    PlatformAssetBundle().loadString(_ASSET_PATH).then((data) {
      setState(() {
        _data = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_data == null) {
      return CircularProgressIndicator();
    }
    return Markdown(data: _data);
  }
}
