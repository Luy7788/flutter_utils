import 'package:flutter/foundation.dart';
import 'package:uni_links/uni_links.dart';

class LinkUtil {

  ///初始化监听代理，
  ///目前只能自动设置iOS
  ///格式：hxfw://proxy?host=192.168.0.1&port=8888

  ///初始化监听代理，
  ///目前只能自动设置iOS
  ///格式：hxfw://proxy?host=192.168.0.1&port=8888
  static void initDeepLinks({Function(String link)? callback}) async {
    // 监听插件scheme数据
    linkStream.listen((String? link) {
      debugPrint("Flutter监听到scheme: $link");
      if (link != null) {
        link = Uri.decodeComponent(link);
        callback?.call(link);
      }
      // Parse the link and warn the user, if it is not correct
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
  }

  // ///手动设置监听代理
  // ///格式：hxfw://proxy?host=192.168.0.1&port=8888
  // static void setupProxyWithLink(String urlScheme) {
  //   _setProxy(urlScheme);
  // }
  //
  // static void _setProxy(String link) {
  //   debugPrint("设置监听代理: $link");
  //   if (link.contains("hxfw://proxy?host") == true) {
  //     // String param = link.replaceAll("hxfw://linkedme/proxy?", "");
  //     String param = link.replaceAll("hxfw://proxy?", "");
  //     Map dict = getUrlParams(param); //设置抓包代理
  //     String host = dict["host"];
  //     String port = dict["port"] ?? "8888";
  //     //这里是网络请求封装
  //     HTTP.setupProxy("PROXY $host:$port");
  //   }
  // }

  ///url参数转map
  static Map getUrlParams(String paramStr) {
    Map map = {};
    List params = paramStr.split("&");
    for (int i = 0; i < params.length; i++) {
      String str = params[i];
      List arr = str.split("=");
      map[arr[0]] = arr[1];
    }
    return map;
  }
}
