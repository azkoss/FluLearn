import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/util/language.dart';
import 'package:flutter_app/util/logger.dart';
import 'package:flutter_app/widget/title_bar.dart';

///
/// 设置页
///
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  List<String> _supportLanguageTags = [
    Language.AUTO_BY_SYSTEM,
    Language.ENGLISH,
    Language.SIMPLIFIED_CHINESE,
  ];
  String _languageTag;
  int _languageIdx;

  @override
  Widget build(BuildContext context) {
    _languageTag = Language.currentTagFromSp();
    _languageIdx = toLangIndex(_languageTag);
    L.d('current language tag is $_languageTag, index is $_languageIdx');
    return Scaffold(
      appBar: TitleBar(
        title: S.of(context).titleSettings,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(S.of(context).settingsLanguage),
                  Text(toLangName(_languageTag)),
                ],
              ),
              leading: Icon(Icons.public),
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _supportLanguageTags.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      value: index,
                      onChanged: (index) {
                        setState(() {
                          _languageTag = _supportLanguageTags[index];
                          _languageIdx = index;
                          Language.change(context, _languageTag);
                        });
                      },
                      groupValue: _languageIdx,
                      title: Text(toLangName(_supportLanguageTags[index])),
                    );
                  },
                )
              ],
            ),
            Divider(),
            ListTile(
              title: Text(S.of(context).settingsTheme),
              leading: Icon(Icons.color_lens),
              trailing: Icon(Icons.chevron_right),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  int toLangIndex(String langTag) {
    if (TextUtil.isEmpty(langTag)) {
      return 0;
    }
    if (langTag.startsWith(Language.ENGLISH)) {
      return 1;
    }
    if (langTag.startsWith(Language.SIMPLIFIED_CHINESE)) {
      return 2;
    }
    return 0;
  }

  String toLangName(String langTag) {
    if (TextUtil.isEmpty(langTag)) {
      return S.of(context).settingsLanguageAutoBySystem;
    }
    if (langTag.startsWith(Language.ENGLISH)) {
      return 'English';
    }
    if (langTag.startsWith(Language.SIMPLIFIED_CHINESE)) {
      return '简体中文';
    }
    return S.of(context).settingsLanguageAutoBySystem;
  }
}
