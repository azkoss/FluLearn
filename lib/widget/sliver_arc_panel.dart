import 'package:flutter/material.dart';

///
///薄片效果的底部半圆弧面板
///
class SliverArcPanel extends StatelessWidget {
  const SliverArcPanel({
    @required this.child,
    this.height = 0,
    this.color,
    this.title,
  })  : assert(child != null),
        assert(height >= 0);

  final Widget child;
  final Color color;
  final double height;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    double _height =
        height > 0 ? height : MediaQuery.of(context).size.width * 0.6;
    Color _color = color == null ? Theme.of(context).primaryColor : color;
    return CustomScrollView(
      physics: ClampingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          floating: true,
          title: title,
        ),
        SliverToBoxAdapter(
          child: Stack(
            children: <Widget>[
              ClipPath(
                clipper: BottomArcClipper(),
                child: Container(
                  height: _height,
                  color: _color,
                ),
              ),
              child,
            ],
          ),
        )
      ],
    );
  }
}

///
/// 底部半圆弧裁剪器
/// Copy from https://github.com/phoenixsky/fun_android_flutter/.../bottom_clipper.dart
///
class BottomArcClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 50);

    var p1 = Offset(size.width / 2, size.height);
    var p2 = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);
    path.lineTo(size.width, size.height - 50);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
