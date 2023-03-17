import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:path_provider/path_provider.dart';

typedef DownloadCallback = void Function(double progress);

class DownloadUtil {

  ///使用dio下载文件
  ///url 地址
  ///savePath 保存路径
  ///progress 下载进度回调
  static Future<bool> downloadFile({
    required String url,
    required String? savePath,
    DownloadCallback? progress,
    CancelToken? cancelToken,
  }) async {
    Dio dio = Dio();
    Response response;
    if (savePath == null) {
      if (Platform.isIOS) {
        savePath = (await getApplicationDocumentsDirectory()).path;
      } else {
        savePath = (await getApplicationSupportDirectory()).path;
      }
      savePath += "/download";
    }
    response = await dio.download(
      url,
      savePath,
      cancelToken: cancelToken,
      onReceiveProgress: (int count, int total) {
        if (progress != null) {
          progress(count/total);
        }
      },
    );
    if (response.statusCode == 200) {
      debugPrint('下载请求成功');
      return true;
    } else {
      return false;
    }
  }

  ///获取图片url转Uint8List
  ///url 图片地址
  static Future<Uint8List?> getNetworkImageUint8List(String url) async {
    Uint8List? imageData = await getNetworkImageData(url, useCache: true);
    if (imageData == null) {
      var result = await http.get(Uri.parse(url));
      if (result.statusCode == 200) {
        Uint8List bodyBytes = result.bodyBytes;
        return bodyBytes;
      } else {
        Dio dio = Dio();
        dio.options.responseType = ResponseType.bytes;
        var response = await dio.get<Uint8List>(url);
        if (response.statusCode == 200) {
          return response.data;
        }
        return null;
      }
    }
    return imageData;
  }

  ///获取url的图片文件
  ///url 图片地址
  static Future<File> getImageFile(String url) async {
    var result = await getCachedImageFile(url);
    if (result == null) {
      await getNetworkImageData(url, useCache: true);
      result = await getCachedImageFile(url);
    }
    return result!;
  }
}
