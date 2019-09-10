import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/config/asset_dir.dart';
import 'package:flutter_app/util/overlay_style.dart';

///
/// 自定义标题栏，类似于[AppBar]
/// Adapted from https://github.com/simplezhli/flutter_deer/.../app_bar.dart
///
class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleBar({
    this.backgroundColor,
    this.leading,
    this.leadingIcon: AssetDir.images + '/ic_back_black.png',
    this.title: '',
    this.centerTitle: true,
    this.action,
    this.actionName: '',
    this.onActionPressed,
  });

  final Color backgroundColor;
  final Widget leading;
  final String leadingIcon;
  final String title;
  final bool centerTitle;
  final Widget action;
  final String actionName;
  final VoidCallback onActionPressed;

  @override
  Size get preferredSize => Size.fromHeight(48.0);

  @override
  Widget build(BuildContext context) {
    final Color _bgColor = backgroundColor ?? Theme.of(context).primaryColor;
    final Color _frontColor = OverlayStyle.estimateFrontColor(_bgColor);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: OverlayStyle.estimateOverlayStyle(_bgColor),
      child: Material(
        color: _bgColor,
        elevation: 1.0,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment:
                        centerTitle ? Alignment.center : Alignment.centerLeft,
                    width: double.infinity,
                    child: Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _frontColor,
                        )),
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  ),
                ],
              ),
              _buildLeading(context, _frontColor),
              Positioned(
                right: 0.0,
                child: Theme(
                  data: ThemeData(
                      buttonTheme: ButtonThemeData(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    minWidth: 60.0,
                  )),
                  child: _buildAction(context, _frontColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext context, Color _frontColor) {
    if (leading != null) {
      return leading;
    }
    if (leadingIcon == null || leadingIcon.isEmpty) {
      return SizedBox();
    }
    return IconButton(
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.maybePop(context);
      },
      padding: const EdgeInsets.all(12.0),
      //icon: Icon(Icons.arrow_back),
      icon: Image.asset(
        leadingIcon,
        color: _frontColor,
      ),
    );
  }

  Widget _buildAction(BuildContext context, Color _frontColor) {
    if (action != null) {
      return action;
    }
    if (actionName.isEmpty) {
      return SizedBox();
    }
    return FlatButton(
      child: Text(actionName),
      textColor: _frontColor,
      highlightColor: Colors.transparent,
      onPressed: onActionPressed,
    );
  }
}
