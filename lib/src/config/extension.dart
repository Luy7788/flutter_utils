import 'package:collection/collection.dart' show IterableExtension;
import 'package:intl/intl.dart';

extension StringExtension on String {
  /*类型转换*/
  int parseInt() {
    return int.parse(this);
  }

  double parseDouble() {
    return double.parse(this);
  }

  //为String类扩展,首字母大写方法
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension FormatDouble on double {
  ///取小数点后几位
  ///location 几位
  String formatNum(int location) {
    if ((toString().length - toString().lastIndexOf(".") - 1) <
        location) {
      //小数点后有几位小数
      return toStringAsFixed(location)
          .substring(0, toString().lastIndexOf(".") + location + 1)
          .toString();
    } else {
      return toString()
          .substring(0, toString().lastIndexOf(".") + location + 1)
          .toString();
    }
  }
}

extension FormatInt on int {
  ///时间格式，不满补0
  String formatTimeNumber({String? newPattern}) {
    final numFormat = NumberFormat(newPattern ?? "00", "en_US");
    return numFormat.format(this);
  }
}

extension IterableExtension<E> on Iterable<E> {
  /// 返回第一个元素。如果内容为空，返回null.
  E? get firstOrNull => isEmpty ? null : first;

  /// 返回第一个符合条件的元素。如果不存在则返回null.
  E? firstOrNullWhere(bool Function(E element) test) {
    return firstWhereOrNull(test);
  }

  /// 过滤掉所有的 null .
  Iterable<E> get excludingNulls => where((e) => e != null);
}

extension FormatEnum on Enum {

  ///获取相应的名字的字符串
  String get getString => enumToString(this);

  ///枚举类型转string
  String enumToString(o) => o.toString().split('.').last;

  ///string转枚举类型
  T? enumFromString<T>(Iterable<T> values, String value) {
    return values.firstWhereOrNull((type) => type.toString().split('.').last == value);
  }
}