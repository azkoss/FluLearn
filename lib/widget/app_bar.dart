import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// 自定义[AppBar]
/// Adapted from https://github.com/simplezhli/flutter_deer/.../app_bar.dart
///
class LyjAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LyjAppBar(
      {Key key,
      this.backgroundColor: Colors.white,
      this.title: "",
      this.centerTitle: "",
      this.actionName: "",
      this.backIcon: "assets/image/ic_back_black.png",
      this.onPressed,
      this.isBack: true})
      : super(key: key);

  final Color backgroundColor;
  final String title;
  final String centerTitle;
  final String backIcon;
  final String actionName;
  final VoidCallback onPressed;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle _overlayStyle =
        ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle,
      child: Material(
        color: backgroundColor,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: centerTitle.isEmpty
                        ? Alignment.centerLeft
                        : Alignment.center,
                    width: double.infinity,
                    child: Text(title.isEmpty ? centerTitle : title,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18,
                          color: _overlayStyle == SystemUiOverlayStyle.light
                              ? Colors.white
                              : Color(0xFF333333),
                        )),
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  )
                ],
              ),
              isBack
                  ? IconButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        Navigator.maybePop(context);
                      },
                      padding: const EdgeInsets.all(12.0),
                      icon: Image.asset(
                        backIcon,
                        color: _overlayStyle == SystemUiOverlayStyle.light
                            ? Colors.white
                            : Color(0xFF333333),
                      ),
                    )
                  : SizedBox(),
              Positioned(
                right: 0.0,
                child: Theme(
                  data: ThemeData(
                      buttonTheme: ButtonThemeData(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    minWidth: 60.0,
                  )),
                  child: actionName.isEmpty
                      ? Container()
                      : FlatButton(
                          child: Text(actionName),
                          textColor: _overlayStyle == SystemUiOverlayStyle.light
                              ? Colors.white
                              : Color(0xFF333333),
                          highlightColor: Colors.transparent,
                          onPressed: onPressed,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48.0);
}
