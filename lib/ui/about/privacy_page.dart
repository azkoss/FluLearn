import 'package:flutter/material.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/ui/widget/back_screen.dart';
import 'package:flutter_app/ui/widget/markdown_viewer.dart';

const _PATH = 'res/PRIVACY.md';

///
/// 隐私声明页
///
class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackScreen(
      presetScroll: false,
      title: S.of(context).titlePrivacy,
      body: MarkdownViewer(path: _PATH),
    );
  }
}
