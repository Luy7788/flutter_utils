import 'package:flutter/material.dart';
import 'package:flutter_utils/src/utils/screens.dart';
import 'dart:ui' as ui;

///适配工具
extension AdaptUtil on Screens {
  static double _width = Screens.width;
  static double _height = Screens.height;
  static final double _topBarH = Screens.topSafeHeight;
  static final double _botBarH = Screens.bottomSafeHeight; //安全距离
  static final double _pixelRatio = Screens.pixelRatio;
  static MediaQueryData? currentWindow;

  /// 安全内容高度(包含 AppBar 和 BottomNavigationBar 高度)
  double get safeContentHeight => _height - _topBarH - _botBarH;

  // /// 实际的安全高度
  // double get safeHeight => safeContentHeight - kToolbarHeight - kBottomNavigationBarHeight;

  /// 根据设计稿提供的宽度，自动调整大小
  /// limitMinSize是否将这个size的值限定为最小值
  static double fitSize(
      double size, {
        bool limitMinSize = true,
      }) {
    return size *
        AdaptUtil.ratio(
          limitMinSize: limitMinSize,
          isWidth: true,
          designWidth: 375,
        );
  }

  /*
  * 适配用，根据当前屏幕宽高返回比例
  * designWidth：设计宽度，(默认width:375, height:667)
  * limitMinSize: 同时设置传入的值为最小值
  * isWidth: true以宽度比较,false以高度比较
  * */
  static double ratio({
    double designWidth = 375,
    double designHeight = 667,
    bool limitMinSize = true,
    bool isWidth = true,
  }) {
    try {
      if (isWidth == true) {
        _width = MediaQueryData.fromWindow(ui.window).size.width;
        double? ratio = _width / designWidth;
        if (limitMinSize == true && ratio < 1.0) {
          return 1.0;
        }
        return ratio;
      } else {
        _height = MediaQueryData.fromWindow(ui.window).size.height;
        double? ratio = _height / designHeight;
        if (limitMinSize == true && ratio < 1.0) {
          return 1.0;
        }
        return ratio;
      }
    } on Exception catch (e) {
      debugPrint('on Exception catch : $e');
      return 1.0;
    } catch (e) {
      debugPrint('catch : $e');
      return 1.0;
    }
  }
  
  static px(number) {
    return number * onePx();
  }

  static onePx() {
    return 1 / _pixelRatio;
  }

  //获取上边距和下边距的值。(主要用于刘海屏)
  static padTopH() {
    return _topBarH;
  }

  static padBotH() {
    return _botBarH;
  }

  //宽高
  static screenW() {
    return _width;
  }

  static screenH() {
    return _height;
  }

  //计算横竖屏
  static screenCurrentH(context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? _height
        : _width;
  }

  static screenCurrentW(context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? _width
        : _height;
  }

  //像素宽高
  static screenPixelW() {
    return ui.window.physicalSize.width;
  }

  static screenPixelH() {
    return ui.window.physicalSize.height;
  }
}