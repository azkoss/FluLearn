import 'package:flutter/material.dart';
import 'package:flutter_app/toolkit/image_loader.dart';

///
/// 头像，类似于[CircleAvatar]
///
class Avatar extends StatelessWidget {
  Avatar({
    this.circle = true,
    @required this.url,
    this.width = 60,
    this.height = 60,
    this.onTap,
  });

  final bool circle;
  final String url;
  final double width;
  final double height;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipOval(
        child: ImageLoader.fromNetwork(url, width: width, height: height),
      ),
    );
  }
}
