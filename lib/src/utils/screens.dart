import 'package:flutter/material.dart';
import 'dart:ui' as ui;

///获取屏幕参数
class Screens {
  const Screens._();

  static MediaQueryData? _data;

  static MediaQueryData get mediaQuery {
    if (_data == null || _data?.size.width == 0){
      _data = MediaQueryData.fromWindow(ui.window);
    }
    return _data ?? MediaQueryData.fromWindow(ui.window);
  }

  static double get pixelRatio => mediaQuery.devicePixelRatio;

  static Size get size => mediaQuery.size;

  static double get width => size.width;

  static int get widthPixels => (width * pixelRatio).toInt();

  static double get height => size.height;

  static int get heightPixels => (height * pixelRatio).toInt();

  static double get topSafeHeight => mediaQuery.padding.top;

  static double get bottomSafeHeight => mediaQuery.padding.bottom;

  static double get safeAreaHeight => topSafeHeight + bottomSafeHeight;

  static double get appBarHeight => topSafeHeight + 44;
}
