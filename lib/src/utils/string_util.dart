import '../config/extension.dart';
class StringUtil {

  ///类型转换 int
  int parseInt(String str) {
    return str.parseInt();
  }

  ///类型转换 double
  double parseDouble(String str) {
    return str.parseDouble();
  }

  ///为String类扩展,首字母大写方法
  String capitalize(String str) {
    return str.capitalize();
  }
}