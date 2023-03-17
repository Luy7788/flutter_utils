import 'package:flutter/cupertino.dart';

class FunctionCall {
  //存放限制
  static final List<String> _limitKeys = [];

  ///限制调用
  ///key：用于区别的标志
  ///func：限制的方法
  ///duration：间隔时间，默认1s
  static Future<bool> callLimit({
    required String key,
    required VoidCallback? func,
    Duration? duration,
  }) async {
    if (_limitKeys.contains(key)) {
      debugPrint("callLimit 限制中，预防频繁触发，key: $key");
      return false;
    } else {
      _limitKeys.add(key);
      try {
        if(func != null) {
          func();
        }
      } catch(e) {
        debugPrint("callLimit error: $e，key: $key");
      }
      await Future.delayed(duration ?? const Duration(seconds: 1));
      _limitKeys.remove(key);
      return false;
    }
  }
}
