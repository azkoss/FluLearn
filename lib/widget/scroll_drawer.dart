import 'package:flutter/material.dart';

///
/// 定制版[Drawer]
/// 参阅 https://www.jianshu.com/p/728692143b09
///
class ScrollDrawer extends StatefulWidget {
  const ScrollDrawer({
    this.color,
    this.elevation = 16.0,
    this.widthPercent,
    this.callback,
    this.physics = const BouncingScrollPhysics(),
    @required this.child,
  }) : assert(widthPercent < 1.0 && widthPercent > 0.0);

  final Color color;
  final double elevation;
  final double widthPercent;
  final DrawerCallback callback;
  final ScrollPhysics physics;
  final Widget child;

  @override
  _ScrollDrawerState createState() => _ScrollDrawerState();
}

class _ScrollDrawerState extends State<ScrollDrawer> {
  @override
  void initState() {
    if (widget.callback != null) {
      widget.callback(true);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.callback != null) {
      widget.callback(false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final double _width =
        MediaQuery.of(context).size.width * widget.widthPercent;
    return ConstrainedBox(
      constraints: BoxConstraints.expand(width: _width),
      child: Material(
        color: widget.color,
        elevation: widget.elevation,
        child: SingleChildScrollView(
          physics: widget.physics,
          child: widget.child,
        ),
      ),
    );
  }
}
