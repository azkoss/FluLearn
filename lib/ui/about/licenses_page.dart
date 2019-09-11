import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/ui/widget/back_screen.dart';

///
/// 开源许可证页
///
/// Adapted from [LicensePage] in 'about.dart' of flutter
///
class LicensesPage extends StatefulWidget {
  const LicensesPage({
    this.legalese,
  });

  final String legalese;

  @override
  _LicensesPageState createState() => _LicensesPageState();
}

class _LicensesPageState extends State<LicensesPage> {
  final List<Widget> _licenses = <Widget>[];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _initLicenses();
  }

  @override
  Widget build(BuildContext context) {
    return BackScreen(
      presetScroll: false,
      title: S.of(context).titleLicenses,
      // All of the licenses page text is English. We don't want localized text
      // or text direction.
      body: Localizations.override(
        locale: const Locale('en', 'US'),
        context: context,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.caption,
          child: Scrollbar(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              children: <Widget>[
                Text(
                  widget.legalese ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(height: 10.0),
                ..._licenses,
                _loaded
                    ? SizedBox.shrink()
                    : const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _initLicenses() async {
    await for (LicenseEntry license in LicenseRegistry.licenses) {
      if (!mounted) {
        return;
      }
      final List<LicenseParagraph> paragraphs =
          await SchedulerBinding.instance.scheduleTask<List<LicenseParagraph>>(
        license.paragraphs.toList,
        Priority.animation,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _licenses.add(const Padding(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            '🍀‬',
            // That's U+1F340. Could also use U+2766 (❦) if U+1F340 doesn't work everywhere.
            textAlign: TextAlign.center,
          ),
        ));
        _licenses.add(Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.0))),
          child: Text(
            license.packages.join(', '),
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ));
        for (LicenseParagraph paragraph in paragraphs) {
          if (paragraph.indent == LicenseParagraph.centeredIndent) {
            _licenses.add(Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                paragraph.text,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ));
          } else {
            assert(paragraph.indent >= 0);
            _licenses.add(Padding(
              padding: EdgeInsetsDirectional.only(
                  top: 8.0, start: 16.0 * paragraph.indent),
              child: Text(paragraph.text),
            ));
          }
        }
      });
    }
    setState(() {
      _loaded = true;
    });
  }
}
