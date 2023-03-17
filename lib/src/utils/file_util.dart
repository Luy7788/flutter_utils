import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_utils/src/utils/permission_util.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  ///删除文件
  ///filePath 文件的完整路径
  static Future<bool> deleteFile({required String filePath}) async {
    try {
      var file = File(filePath);
      if (await file.exists()) {
        //文件存在就删除
        await file.delete();
      }
      return true;
    } catch (e) {
      debugPrint("删除文件失败: $e");
      return false;
    }
  }

  ///获取临时文件目录
  ///如果不存在会创建目录
  static Future<String?> getTempFilePath({
    String? savePath,
    String? fileName,
  }) async {
    var directory = await getTemporaryDirectory();
    try {
      if (savePath == null) {
        savePath =
            "${directory.path}/Flutter/${fileName ?? DateTime.now().millisecondsSinceEpoch}";
      } else if (fileName != null) {
        if (savePath.contains(fileName) == false) {
          String tempString = savePath.substring(savePath.length - 1);
          debugPrint("savePath.substring: $tempString");
          if (tempString == "/") {
            savePath = "$savePath$fileName";
          } else {
            savePath = "$savePath/$fileName";
          }
        }
      }
      File file = File(savePath);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      return savePath;
    } catch (e) {
      debugPrint("获取临时文件目录失败 $e");
      return null;
    }
  }

  ///保存图片到相册
  ///imageBytes: 图片数据
  ///fileName 文件名
  static Future<String?> saveImageToAlbum(
    Uint8List imageBytes, {
    String? fileName,
  }) async {
    bool result = await PermissionUtil.checkPhotoAndStoragePermission();
    if (result == true) {
      Map? result = await ImageGallerySaver.saveImage(
        imageBytes,
        quality: 100,
        name: fileName,
        isReturnImagePathOfIOS: true,
      );
      debugPrint("saveImageToAlbum result $result");
      if (result?["isSuccess"] == true) {
        return result?["filePath"] ?? "";
      } else {
        return null;
      }
    }
    return null;
  }

  ///保存文件(PNG，JPG，JPEG or video)到系统相册
  ///filePath: 保存的文件路径
  static Future<String?> saveFileToAlbum(String filePath) async {
    bool result = await PermissionUtil.checkPhotoAndStoragePermission();
    if (result == true) {
      final result = await ImageGallerySaver.saveFile(filePath);
      debugPrint("saveFileToAlbum result $result");
      if (result["isSuccess"] == true) {
        return result["filePath"] ?? "";
      } else {
        return null;
      }
    }
    return null;
  }

  ///保存文件到指定路径,返回路径
  ///bytes：Uint8List数据
  ///savePath：保存路径,eg: /Flutter/poster/ ，不填则在缓存目录的Flutter目录
  ///fileName: 文件名称,不填写则用时间戳
  static Future<String?> saveFileToPath({
    required Uint8List? bytes,
    String? savePath,
    String? fileName,
  }) async {
    bool result = await PermissionUtil.checkPhotoAndStoragePermission();
    if (result == true) {
      if (savePath == null) {
        var directory = await getTemporaryDirectory();
        savePath =
            "${directory.path}/Flutter/${fileName ?? DateTime.now().millisecondsSinceEpoch}";
      } else if (fileName != null) {
        if (savePath.contains(fileName) == false) {
          String tempString = savePath.substring(savePath.length - 1);
          debugPrint("savePath.substring: $tempString");
          if (tempString == "/") {
            savePath = "$savePath$fileName";
          } else {
            savePath = "$savePath/$fileName";
          }
        }
      }
      File file = File(savePath);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      File file1 = await file.writeAsBytes(bytes!);
      if (file1.existsSync()) {
        debugPrint("saveFileToPath success $savePath");
        return savePath;
      }
      debugPrint("saveFileToPath fail $savePath");
      return null;
    }
    return null;
  }

  /*
  保存海报文件到缓存地址
  isSDPath: 是否保存海报文件到sd海报地址,iOS这保存相册
  * */
  static Future<String?> savePosterImageToAlbum({
    required Uint8List? bytes,
    String? fileName,
    bool? isSDPath,
    String? filePath,
  }) async {
    bool result = await PermissionUtil.checkPhotoAndStoragePermission();
    if (result == true) {
      var directory;
      if (isSDPath == true) {
        if (Platform.isIOS) {
          directory = await getLibraryDirectory();
        } else {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getTemporaryDirectory();
      }
      String savePath = directory.path +
          (filePath ?? '/city/poster/') +
          (fileName ?? "${DateTime.now().millisecondsSinceEpoch}.png");
      File file = File(savePath);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      File file1 = await file.writeAsBytes(bytes!);
      if (file1.existsSync()) {
        debugPrint("savePosterImageToPath success $savePath");
        return savePath;
      }
      debugPrint("savePosterImageToPath fail $savePath");
      return null;
    }
    return null;
  }

  /// 获取缓存大小
  Future<String> getAppCacheSize() async {
    Directory tempDir = await getTemporaryDirectory();
    bool isE = await tempDir.exists();
    if (!isE) return "0 B";
    List<FileSystemEntity> fileDir = tempDir.listSync();
    int total = 0;
    if (fileDir.isNotEmpty)
      for (FileSystemEntity child in fileDir) {
        total += await _reduce(child);
      }
    return renderSize(total);
  }

  /// 清除缓存
  Future<void> clearAppCache() async {
    Directory tempDir = await getTemporaryDirectory();
    bool isE = await tempDir.exists();
    if (!isE) return;
    await _delete(tempDir);
  }

  /// 递归缓存目录，计算缓存大小
  Future<int> _reduce(final FileSystemEntity file) async {
    bool isE = await file.exists();
    if (isE && !file.path.contains('Library/Caches/Snapshots')) {
      /// 如果是一个文件，则直接返回文件大小
      if (file is File) {
        int length = await file.length();
        return length;
      } else if (file is Directory) {
        /// 如果是目录，则遍历目录并累计大小
        final List<FileSystemEntity> children = file.listSync();
        int total = 0;
        if (children.isNotEmpty)
          for (FileSystemEntity child in children) {
            total += await _reduce(child);
          }
        return total;
      }
    }
    return 0;
  }

  /// 递归删除缓存目录和文件
  static Future<void> _delete(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (FileSystemEntity child in children) {
        await _delete(child);
      }
    } else {
      await file.delete();
    }
  }

//格式化文件大小
  String renderSize(value) {
    if (value == null) {
      return '0.0';
    }
    List<String> unitArr = ['B', 'K', 'M', 'G'];
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
}
