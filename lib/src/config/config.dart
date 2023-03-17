import 'dart:io';
import 'package:flutter/foundation.dart';

class Config {
  ///运行模式
  static const isDebug = !kReleaseMode;

  static const isRelease = kReleaseMode;

  static final isIOS = Platform.isIOS;

  static final isAndroid = Platform.isAndroid;
}
