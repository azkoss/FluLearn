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
    Key key,
    this.behindColor: Colors.white,
    this.leading,
    this.backIcon: AssetDir.images + '/ic_back_black.png',
    this.title: "",
    this.centerTitle: true,
    this.action,
    this.actionName: '',
    this.onActionPressed,
  }) : super(key: key);

  final Color behindColor;
  final Widget leading;
  final String backIcon;
  final String title;
  final bool centerTitle;
  final Widget action;
  final String actionName;
  final VoidCallback onActionPressed;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: OverlayStyle.estimateOverlayStyle(behindColor),
      child: Material(
        color: behindColor,
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
                          color: OverlayStyle.estimateFrontColor(behindColor),
                        )),
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  )
                ],
              ),
              _buildLeading(context),
              Positioned(
                right: 0.0,
                child: Theme(
                  data: ThemeData(
                      buttonTheme: ButtonThemeData(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    minWidth: 60.0,
                  )),
                  child: _buildAction(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    if (leading != null) {
      return leading;
    }
    if (backIcon == null || backIcon.isEmpty) {
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
        backIcon,
        color: OverlayStyle.estimateFrontColor(behindColor),
      ),
    );
  }

  Widget _buildAction(BuildContext context) {
    if (action != null) {
      return action;
    }
    if (actionName.isEmpty) {
      return SizedBox();
    }
    return FlatButton(
      child: Text(actionName),
      textColor: OverlayStyle.estimateFrontColor(behindColor),
      highlightColor: Colors.transparent,
      onPressed: onActionPressed,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48.0);
}
