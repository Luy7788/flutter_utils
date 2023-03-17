import 'dart:ui';
import 'package:flutter/cupertino.dart';

class ColorUtil {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString,{String? defaultColor}) {
    final buffer = StringBuffer();
    if(hexString.isNotEmpty){
      hexString = hexString.replaceAll("0x", "");
    }else{
      hexString = defaultColor?.replaceAll("0x", "") ?? 'ffffff';
    }
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  //渐变颜色, 预防空时显示默认色
  static Color gradientChangeFrom({String? formColor}) {
    return ColorUtil.fromHex(formColor?.isNotEmpty == true ? formColor! : "124553");
  }

  //渐变颜色, 预防空时显示默认色
  static Color gradientChangeTo({String? toColor}) {
    return ColorUtil.fromHex(toColor?.isNotEmpty == true ? toColor! : "23363D");
  }

  //转换#AARRGGBB
  static String? toHexString(Color? color, {bool alpha = false}) {
    if (color != null) {
      String tmpColor;
      tmpColor = "#${color.value.toRadixString(16).padLeft(8, '0')}";
      if (alpha == false) {
        tmpColor = tmpColor.substring(3);
      }
      debugPrint("toHexString: $tmpColor");
      return tmpColor;
    } else {
      return null;
    }
  }

}
