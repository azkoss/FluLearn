import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/asset_dir.dart';

///
/// 图片加载工具类
/// Adapted from https://github.com/simplezhli/flutter_deer/.../image_utils.dart
///
class ImageLoader {
  static const String placeholder = AssetDir.images + '/ic_placeholder.png';

  static String assetPath(String name) {
    return name.startsWith(AssetDir.images)
        ? name
        : AssetDir.images + '/' + name;
  }

  ///
  /// 加载本地资源图片
  ///
  static Widget fromAsset(
    String name, {
    double width,
    double height,
    BoxFit fit,
  }) {
    if (TextUtil.isEmpty(name)) {
      return SizedBox.shrink();
    }
    return Image.asset(
      assetPath(name),
      height: height,
      width: width,
      fit: fit,
    );
  }

  ///
  /// 加载网络图片
  ///
  static Widget fromNetwork(
    String imageUrl, {
    double width,
    double height,
    BoxFit fit: BoxFit.cover,
    String placeholder: placeholder,
    bool cacheEnable: true,
  }) {
    if (TextUtil.isEmpty(imageUrl) || !imageUrl.startsWith('http')) {
      return fromAsset(placeholder, height: height, width: width, fit: fit);
    }
    if (cacheEnable) {
      return new CachedNetworkImage(
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
    return FadeInImage.assetNetwork(
      placeholder: placeholder,
      image: imageUrl,
      height: height,
      width: width,
      fit: fit,
    );
  }

  static ImageProvider fromProvider(String imageUrl,
      [ErrorListener errorListener]) {
    if (TextUtil.isEmpty(imageUrl)) {
      return AssetImage(placeholder);
    }
    if (imageUrl.startsWith("http")) {
      return new CachedNetworkImageProvider(
        imageUrl,
        errorListener: errorListener,
      );
    }
    return new AssetImage(assetPath(imageUrl));
  }
}
