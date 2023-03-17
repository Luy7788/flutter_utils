import 'dart:math';
import '../config/extension.dart';

class NumUtil {

  static Random random = Random.secure();

  ///获取随机数
  static int randomInt({int maxNum = 1000}) {
    return random.nextInt(maxNum);
  }

  static double randomDouble() {
    return random.nextDouble();
  }

  ///格式化double,保留小数位
  ///decimalNum 保留小数点位数
  static String doubleFormat(double num, int decimalNum) {
    return num.formatNum(decimalNum);
  }

  ///格式化int，默认格式两位数，不够补0
  static String intFormat(int num, {String? newPattern}) {
    return num.formatTimeNumber(newPattern: newPattern);
  }

}