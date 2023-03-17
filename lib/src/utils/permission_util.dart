import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_utils/src/config/config.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {

  ///检查通知权限
  static Future<bool> checkNoticePermission() async {
    Map<Permission, PermissionStatus> statuses = await [Permission.notification].request();
    var currentStatus = statuses[Permission.notification];
    final info = currentStatus.toString();
    debugPrint("checkNoticePermission $info");
    if (currentStatus == PermissionStatus.granted || currentStatus == PermissionStatus.limited) {
      return true;
    } else {
      return false;
    }
  }

  ///检查摄像头权限
  static Future<bool> checkCameraPermission() async {
    Map<Permission, PermissionStatus> statuses =  await [Permission.camera].request();
    var currentStatus = statuses[Permission.camera];
    final info = currentStatus.toString();
    debugPrint("checkCameraPermission $info");
    if (currentStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  ///iOS检查相册权限
  ///安卓检查读写权限
  static Future<bool> checkPhotoAndStoragePermission() async {
    if (Config.isIOS) {
      return _checkPhotoPermission();
    } else {
      return _checkStoragePermission();
    }
  }

  ///检查是否有相册权限
  static Future<bool> _checkPhotoPermission() async {
    // if (await Permission.photos.isPermanentlyDenied == true) {
    //   openAppSettings();
    //   return false;
    // }
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos, Permission.photosAddOnly
    ].request();
    bool photosStatusEnable = (statuses[Permission.photos] == PermissionStatus.granted || statuses[Permission.photos] == PermissionStatus.limited);
    bool photosAddOnlyStatusEnable = (statuses[Permission.photosAddOnly] == PermissionStatus.granted || statuses[Permission.photosAddOnly] == PermissionStatus.limited);
    debugPrint("checkPhotoPermission photosStatus:${statuses[Permission.photos]}");
    debugPrint("checkPhotoPermission photosAddOnlyStatus:${statuses[Permission.photosAddOnly]}");
    if (photosStatusEnable == true || photosAddOnlyStatusEnable == true) {
      return true;
    } else {
      return false;
    }
  }

  ///检查是否已有读写权限
  static Future<bool> _checkStoragePermission() async {
    // if (Config.isAndroid == true && Config.isBoostMode == true) {
    //   return true;
    // }
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    var currentStatus = statuses[Permission.storage];
    final info = currentStatus.toString();
    debugPrint("checkStoragePermission $info");
    if (currentStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> checkMediaLibraryPermission() async {
    Map<Permission, PermissionStatus> statuses =  await [Permission.mediaLibrary].request();
    var currentStatus = statuses[Permission.mediaLibrary];
    final info = currentStatus.toString();
    debugPrint("checkMediaLibraryPermission $info");
    if (currentStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  ///打开设置页
  static void openAppSetting() {
    // openAppSettings();
    AppSettings.openAppSettings();
  }

  ///打开通知设置
  static void openNoticeSetting() {
    AppSettings.openNotificationSettings();
  }

}