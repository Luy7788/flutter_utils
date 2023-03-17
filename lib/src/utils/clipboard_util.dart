import 'package:flutter/services.dart';

//复制粘贴工具
class ClipboardUtil {

  //复制内容
  static Future setData(String? data)  {
    if (data == null) {
      return Clipboard.setData(const ClipboardData(text: ""));
    }
    return Clipboard.setData(ClipboardData(text: data));
  }

  //获取粘贴板内容
  static Future<String?> getData() async {
    if (await Clipboard.hasStrings() == true) {
      var data = await Clipboard.getData(Clipboard.kTextPlain);
      return data?.text;
    }
    return null;
  }

}
