import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///
/// 图片加载工具类
/// Adapted from https://github.com/simplezhli/flutter_deer/.../image_utils.dart
///
class ImageUtils {
  static const String placeholder = "assets/image/ic_placeholder.png";

  ///
  /// 加载本地资源图片
  ///
  static Widget fromAsset(String name,
      {double width, double height, BoxFit fit}) {
    return Image.asset(
      name.startsWith("assets") ? name : "assets/image/$name",
      height: height,
      width: width,
      fit: fit,
    );
  }

  ///
  /// 加载网络图片
  ///
  static Widget fromNetwork(String imageUrl,
      {double width,
      double height,
      BoxFit fit: BoxFit.cover,
      String placeholder: placeholder}) {
    if (TextUtil.isEmpty(imageUrl)) {
      return fromAsset(placeholder, height: height, width: width, fit: fit);
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) =>
          fromAsset(placeholder, height: height, width: width, fit: fit),
      errorWidget: (context, url, error) =>
          fromAsset(placeholder, height: height, width: width, fit: fit),
      width: width,
      height: height,
      fit: fit,
    );
  }

  static ImageProvider fromProvider(String imageUrl,
      {String placeholder: placeholder}) {
    if (TextUtil.isEmpty(imageUrl)) {
      return AssetImage(placeholder);
    }
    return CachedNetworkImageProvider(imageUrl);
  }
}
