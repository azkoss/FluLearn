import 'package:flutter/material.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/toolkit/l.dart';
import 'package:flutter_app/toolkit/language_kit.dart';
import 'package:flutter_app/toolkit/theme_kit.dart';
import 'package:flutter_app/ui/widget/back_screen.dart';

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
  int _languageIdx;

  @override
  void initState() {
    _languageIdx = LanguageKit.tagIndex;
    L.d('current language tag is ${LanguageKit.tag}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackScreen(
      title: S.of(context).titleSettings,
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          _buildLanguageTile(context),
          Divider(),
          _buildBrightnessTile(context),
          Divider(),
          _buildThemeTile(context),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return Material(
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(S.of(context).settingsLanguage),
            Text(LanguageKit.toFriendlyName(context, _languageIdx)),
          ],
        ),
        leading: Icon(Icons.public),
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            itemCount: LanguageKit.SUPPORT_TAGS.length,
            itemBuilder: (context, index) {
              return RadioListTile(
                value: index,
                onChanged: (index) {
                  setState(() {
                    _languageIdx = index;
                    LanguageKit.change(tagIndex: _languageIdx);
                  });
                },
                groupValue: _languageIdx,
                title: Text(LanguageKit.toFriendlyName(context, index)),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildBrightnessTile(BuildContext context) {
    return Material(
      child: ListTile(
        title: Text(S.of(context).settingsDarkMode),
        onTap: () {
          ThemeKit.changeBrightness(ThemeKit.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light);
        },
        leading: Icon(
          ThemeKit.brightness == Brightness.light
              ? Icons.brightness_2
              : Icons.brightness_7,
        ),
        trailing: Switch(
            activeColor: Theme.of(context).accentColor,
            value: ThemeKit.brightness == Brightness.dark,
            onChanged: (value) {
              ThemeKit.changeBrightness(
                  value ? Brightness.dark : Brightness.light);
            }),
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    return Material(
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(S.of(context).settingsTheme),
            Container(
              width: 15,
              height: 15,
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
        leading: Icon(Icons.color_lens),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: <Widget>[
                ...ThemeKit.SUPPORT_COLORS.map((color) {
                  return Material(
                    color: color,
                    child: InkWell(
                      onTap: () {
                        ThemeKit.changeColor(color);
                      },
                      child: SizedBox(
                        width: 40,
                        height: 40,
                      ),
                    ),
                  );
                }).toList(),
                Material(
                  child: InkWell(
                    onTap: () {
                      ThemeKit.changeRandomColor();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).accentColor),
                      ),
                      width: 40,
                      height: 40,
                      child: Text(
                        "?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
