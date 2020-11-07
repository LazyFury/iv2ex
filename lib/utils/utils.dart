import 'dart:ui';
import 'package:flutter/material.dart';

// safearea
EdgeInsets safeArea(BuildContext c) => MediaQuery.of(c).padding;
// 屏幕尺寸
Size screenSize(BuildContext context) => MediaQuery.of(context).size;

String replaceImageUrl(String url, String origin) {
  RegExp hasProtocol = RegExp(r"http[s]{0,1}://");
  if (!hasProtocol.hasMatch(url)) {
    url = origin + url;
  }
  return url;
}

// 设计尺寸
class DesignSize {
  BuildContext context;
  int designWidth;
  int designHeight; //暂时保留，应该根据宽度计算比例就可以了
  DesignSize(this.context, {this.designWidth = 375, this.designHeight = 667});

  static DesignSize _instance;

  static DesignSize of(BuildContext context) {
    if (_instance == null) {}
    _instance = new DesignSize(context);
    return _instance;
  }

  Size get realSize {
    return screenSize(this.context);
  }

  double get scale {
    return this.designWidth / this.realSize.width;
  }

  double calc(double n) {
    // print(this.scale);
    // print(this.realSize);
    // print(this.designWidth);
    return (n * this.scale).toDouble();
  }
}
