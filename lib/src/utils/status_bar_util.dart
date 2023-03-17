import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//设置状态栏
class StatusBarUtil {

  //字体黑色
  static const darkText = SystemUiOverlayStyle(
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
    // statusBarColor: Color(0xFFFFFFFF),
    systemNavigationBarColor: Color(0xFF000000), //Colors.white,//
    systemNavigationBarDividerColor: Color(0xFF000000), //Colors.white,
  );

  //字体白色
  static const lightText = SystemUiOverlayStyle(
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    // statusBarColor: Color(0xFFFFFFFF),
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarDividerColor: Color(0xFF000000),
  );


  ///状态栏字体颜色
  ///isDark：是，黑色字体；否，白色字体
  static setupTextStyle({required bool isDark}) {
    if (isDark == true) {
      SystemChrome.setSystemUIOverlayStyle(
        StatusBarUtil.darkText,
        // SystemUiOverlayStyle(
        //   statusBarIconBrightness: Brightness.dark,
        // ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        StatusBarUtil.lightText,
        // SystemUiOverlayStyle.light,
        // SystemUiOverlayStyle(
        //   statusBarIconBrightness: Brightness.light,
        // ),
      );
    }
    // NativeChannel.setupStatuesBar(isDark: isDark);
  }
}
