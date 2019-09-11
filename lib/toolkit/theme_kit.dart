import 'dart:math' show Random;

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart'
    show CupertinoThemeData, CupertinoTextThemeData;
import 'package:flutter/material.dart';
import 'package:flutter_app/config/prefs_key.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/main.dart';

///
/// 主题色彩工具类
/// Adapted from https://github.com/phoenixsky/fun_android_flutter/.../theme_model.dart
///
class ThemeKit {
  static const SUPPORT_COLORS = Colors.primaries;
  static const SUPPORT_FONTS = ['', 'kuaile'];
  static int _brightnessIndex = -1;
  static MaterialColor _color;
  static String _font;
  static ThemeData _themeData;

  static ThemeData get themeData {
    //Theme.of(context)
    if (_themeData == null) {
      _themeData = generate(brightness: brightness, color: color, font: font);
    }
    return _themeData;
  }

  static Brightness get brightness {
    if (_brightnessIndex == -1) {
      _brightnessIndex = SpUtil.getInt(PrefsKey.theme_brightness_index,
          defValue: Brightness.light.index);
    }
    return Brightness.values[_brightnessIndex];
  }

  static MaterialColor get color {
    if (_color == null) {
      int index = SpUtil.getInt(PrefsKey.theme_color_index, defValue: 5);
      if (index == -1) {
        index = 0;
      }
      _color = SUPPORT_COLORS[index];
    }
    return _color;
  }

  static String get font {
    if (_font == null) {
      int index = SpUtil.getInt(PrefsKey.theme_font_index, defValue: 0);
      if (index == -1) {
        index = 0;
      }
      _font = SUPPORT_FONTS[index];
    }
    return _font;
  }

  static void changeBrightness(Brightness brightness) {
    _change(brightness: brightness, color: color);
  }

  static void changeRandomColor() {
    int randomColorIndex = Random().nextInt(SUPPORT_COLORS.length - 1);
    MaterialColor color = SUPPORT_COLORS[randomColorIndex];
    _change(brightness: brightness, color: color);
  }

  static void changeColor(MaterialColor color) {
    _change(brightness: brightness, color: color);
  }

  static void changeFont(String font) {
    _change(brightness: brightness, color: color, font: font);
  }

  static void _change(
      {@required Brightness brightness,
      @required MaterialColor color,
      String font}) {
    _themeData = generate(brightness: brightness, color: color, font: font);
    appStateKey.currentState.changeThemeData(_themeData);
    _brightnessIndex = brightness.index;
    SpUtil.putInt(PrefsKey.theme_brightness_index, _brightnessIndex);
    int colorIndex = SUPPORT_COLORS.indexOf(color);
    if (colorIndex == -1) {
      colorIndex = 0;
    }
    _color = SUPPORT_COLORS[colorIndex];
    SpUtil.putInt(PrefsKey.theme_color_index, colorIndex);
    int fontIndex = SUPPORT_FONTS.indexOf(font);
    if (fontIndex == -1) {
      fontIndex = 0;
    }
    _font = SUPPORT_FONTS[fontIndex];
    SpUtil.putInt(PrefsKey.theme_font_index, fontIndex);
  }

  ///
  /// 根据亮度、颜色及字体生成对应的主题.
  ///
  static ThemeData generate(
      {Brightness brightness, MaterialColor color, String font}) {
    bool isDark = Brightness.dark == brightness;
    Color bgColor = isDark ? Colors.grey[850] : Colors.grey[100];
    Color accentColor = isDark ? color[700] : color;
    ThemeData themeData = new ThemeData(
      brightness: brightness,
      backgroundColor: bgColor,
      scaffoldBackgroundColor: bgColor,
      primaryColorBrightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      primarySwatch: color,
      accentColor: accentColor,
      fontFamily: font,
    );
    themeData = themeData.copyWith(
      appBarTheme: themeData.appBarTheme.copyWith(elevation: 0),
      splashColor: color.withAlpha(50),
      hintColor: themeData.hintColor.withAlpha(90),
      errorColor: Colors.red,
      cursorColor: accentColor,
      textSelectionColor: accentColor.withAlpha(60),
      textSelectionHandleColor: accentColor.withAlpha(60),
      toggleableActiveColor: accentColor,
      dividerTheme: themeData.dividerTheme.copyWith(
        space: 0,
        thickness: 0.7,
      ),
      chipTheme: themeData.chipTheme.copyWith(
        pressElevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        labelStyle: themeData.textTheme.caption,
        backgroundColor: themeData.chipTheme.backgroundColor.withOpacity(0.1),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: color,
        brightness: brightness,
        textTheme: CupertinoTextThemeData(brightness: Brightness.light),
      ),
      inputDecorationTheme: _inputDecorationTheme(themeData),
    );

    return themeData;
  }

  static String fontFriendlyName(BuildContext context, int index) {
    switch (index) {
      default:
        return S.of(context).settingsAutoBySystem;
    }
  }

  static InputDecorationTheme _inputDecorationTheme(ThemeData theme) {
    Color primaryColor = theme.primaryColor;
    Color dividerColor = theme.dividerColor;
    Color errorColor = theme.errorColor;
    Color disabledColor = theme.disabledColor;
    double width = 0.5;
    return InputDecorationTheme(
      hintStyle: TextStyle(fontSize: 14),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: width, color: errorColor),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 0.7, color: errorColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: width, color: primaryColor),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: width, color: dividerColor),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(width: width, color: dividerColor),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: width, color: disabledColor),
      ),
    );
  }
}
