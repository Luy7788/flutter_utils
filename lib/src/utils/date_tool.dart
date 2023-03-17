import 'package:common_utils/common_utils.dart';
import 'package:flutter_utils/src/config/extension.dart';
import 'package:intl/intl.dart';

///补充[DateUtil]
class DateTool {
  ///比较b和a相差多久
  static int compareDates(
    DateTime a,
    DateTime b, {
    bool day = true,
    bool hours = false,
    bool minutes = false,
    bool seconds = false,
  }) {
    var difference = b.difference(a);
    if (day == true) return difference.inDays;
    if (hours == true) return difference.inHours;
    if (minutes == true) return difference.inMinutes;
    if (seconds == true) return difference.inSeconds;
    return difference.inDays;
  }

  ///格式化日期，也可自定义
  // * class DateFormats {
  //   static String full = 'yyyy-MM-dd HH:mm:ss';
  //   static String y_mo_d_h_m = 'yyyy-MM-dd HH:mm';
  //   static String y_mo_d = 'yyyy-MM-dd';
  //   static String y_mo = 'yyyy-MM';
  //   static String mo_d = 'MM-dd';
  //   static String mo_d_h_m = 'MM-dd HH:mm';
  //   static String h_m_s = 'HH:mm:ss';
  //   static String h_m = 'HH:mm';
  //   static String zh_full = 'yyyy年MM月dd日 HH时mm分ss秒';
  //   static String zh_y_mo_d_h_m = 'yyyy年MM月dd日 HH时mm分';
  //   static String zh_y_mo_d = 'yyyy年MM月dd日';
  //   static String zh_y_mo = 'yyyy年MM月';
  //   static String zh_mo_d = 'MM月dd日';
  //   static String zh_mo_d_h_m = 'MM月dd日 HH时mm分';
  //   static String zh_h_m_s = 'HH时mm分ss秒';
  //   static String zh_h_m = 'HH时mm分';
  // }
  static String formatDate({
    DateTime? dateTime,
    String? dateString,
    int? dateInt,
    required String format,
  }) {
    if (dateInt != null) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(dateInt);
      return DateUtil.formatDate(date, format: format);
    } else if (dateTime != null) {
      return DateUtil.formatDate(dateTime, format: format);
    } else {
      return DateUtil.formatDateStr(dateString!, format: format);
    }
  }

  /// 根据时间获取昨天
  /// format 转换格式(已提供常用格式 DateFormats，可以自定义格式：'yyyy/MM/dd HH:mm:ss')
  static String yesterday({
    DateTime? dateTime,
    String? date,
    required String format,
  }) {
    if (dateTime != null) {
      DateTime yesterday = dateTime.subtract(const Duration(days: 1));
      return DateUtil.formatDate(yesterday, format: format);
    } else {
      DateTime dateTime = DateUtil.getDateTime(date!)!;
      DateTime yesterday = dateTime.subtract(const Duration(days: 1));
      return DateUtil.formatDate(yesterday, format: format);
    }
  }

  /// 根据时间获取明天
  /// format 转换格式(已提供常用格式 DateFormats，可以自定义格式：'yyyy/MM/dd HH:mm:ss')
  static String tomorrow({
    DateTime? dateTime,
    String? date,
    required String format,
  }) {
    if (dateTime != null) {
      DateTime tomorrow = dateTime.add(const Duration(days: 1));
      return DateUtil.formatDate(tomorrow, format: format);
    } else {
      DateTime dateTime = DateUtil.getDateTime(date!)!;
      DateTime tomorrow = dateTime.add(const Duration(days: 1));
      return DateUtil.formatDate(tomorrow, format: format);
    }
  }

  ///根据时间获取周几
  ///返回格式星期一
  static String getWeekday({
    DateTime? dateTime,
    String? date,
  }) {
    if (dateTime != null) {
      return DateUtil.getWeekday(dateTime, languageCode: "zh");
    } else {
      DateTime? dateTime = DateUtil.getDateTime(date!);
      return DateUtil.getWeekday(dateTime, languageCode: "zh");
    }
  }

  ///根据时间获取哪个月
  static int getMonth({DateTime? dateTime, String? date}) {
    if (dateTime != null) {
      return dateTime.month;
    } else {
      DateTime dateTime = DateUtil.getDateTime(date!)!;
      return dateTime.month;
    }
  }

  ///获取日期是当月第几天
  static int getDay({DateTime? dateTime, String? date}) {
    if (dateTime != null) {
      return dateTime.day;
    } else {
      DateTime dateTime = DateUtil.getDateTime(date!)!;
      return dateTime.day;
    }
  }

  ///获取当前时间
  static String currentTime() {
    var now = DateTime.now();
    return now.toLocal().toString();
  }

  ///格式化为年-月-日-时-分-秒
  static String tranFormatTime(int timestamp) {
    if (timestamp == 0) {
      return "";
    }
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final numFormat = NumberFormat("00", "en_US");
    String formatTime =
        '${date.year}-${date.month}-${date.day} ${numFormat.format(date.hour)}:${numFormat.format(date.minute)}:${numFormat.format(date.second)}';
    return formatTime;
  }

  ///多久前
  ///格式：多少小时前、多少分钟前、刚刚
  static String readTimestamp(int timestamp) {
    String temp = "";
    if (timestamp == 0) {
      return temp;
    }
    try {
      int now = DateTime.now().millisecondsSinceEpoch;
      int diff = (now - timestamp) ~/ 1000;
      int months = (diff ~/ (60 * 60 * 24 * 30));
      int days = (diff ~/ (60 * 60 * 24));
      int hours = ((diff - days * (60 * 60 * 24)) ~/ (60 * 60));
      int minutes = ((diff - days * (60 * 60 * 24) - hours * (60 * 60)) ~/ 60);
      if (months > 0) {
        // temp = months.toString() + "月前";
        temp = tranFormatTime(timestamp);
      } else if (days > 0) {
        // temp = days.toString() + "天前";
        temp = tranFormatTime(timestamp);
      } else if (hours > 0) {
        temp = "$hours小时前";
      } else if (minutes < 10) {
        temp = "刚刚";
      } else {
        temp = "$minutes分钟前";
      }
    } catch (e) {
      e.toString();
      return "";
    }
    return temp;
  }

  ///输出时间：时：分：秒-> 00:00:00
  static String formatTime(int allSecond) {
    int hours = (allSecond ~/ (60 * 60));
    int minutes = ((allSecond - hours * (60 * 60)) ~/ 60);
    int second = allSecond % 60;
    // final numFormat = new NumberFormat("00", "en_US");
    if (allSecond > 60 * 60) {
      return "${hours.formatTimeNumber()}:${minutes.formatTimeNumber()}:${second.formatTimeNumber()}";
    } else {
      return "${minutes.formatTimeNumber()}:${second.formatTimeNumber()}";
    }
  }

  ///时间戳转日期
  ///[timestamp] 时间戳
  ///[onlyNeedDate ] 是否只显示日期 舍去时间
  static String timestampToDateStr(
    int timestamp, {
    onlyNeedDate = true,
  }) {
    DateTime dataTime = timestampToDate(timestamp);
    String dateTime = dataTime.toString();

    ///去掉时间后面的.000
    dateTime = dateTime.substring(0, dateTime.length - 4);
    if (onlyNeedDate) {
      List<String> dataList = dateTime.split(" ");
      dateTime = dataList[0];
    }
    return dateTime;
  }

  static DateTime timestampToDate(int timestamp) {
    DateTime dateTime = DateTime.now();
    dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return dateTime;
  }
}
