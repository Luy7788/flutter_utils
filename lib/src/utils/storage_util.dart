import 'package:shared_preferences/shared_preferences.dart';

StorageUtil appStorage = StorageUtil();

///持久化工具
class StorageUtil {
  static SharedPreferences get storage => _prefs;
  static late final SharedPreferences _prefs;

  StorageUtil() {
    SharedPreferences.getInstance().then((value) => StorageUtil._prefs = value);
  }

  SharedPreferences? _getStorage() {
    return storage;
  }

  ///获取存储的值
  ///T 类型可为：bool|int|double|String|List
  ///key [StorageKey]
  ///salt key加盐
  T? getValue<T>({
    required String key,
    String? salt,
  }) {
    SharedPreferences? p = _getStorage();
    if (p == null) return null;
    if (salt?.isNotEmpty == true) {
      key = key + salt!;
    }
    if (T == bool) {
      return p.getBool(key) as T?;
    } else if (T == int) {
      return p.getInt(key) as T?;
    } else if (T == double) {
      return p.getDouble(key) as T?;
    } else if (T == String) {
      return p.getString(key) as T?;
    } else if (T == List) {
      return p.getStringList(key) as T?;
    }
    return null;
  }

  ///存储值
  ///value支持类型：bool|int|double|String|List<String>
  ///key [StorageKey]
  ///salt key加盐
  ///return 成功|失败
  Future<bool> setValue({
    required String key,
    required dynamic value,
    String? salt,
  }) async {
    SharedPreferences? p = _getStorage();
    if (p == null) {
      await Future.delayed(const Duration(milliseconds: 50));
      p = _getStorage();
    }
    if (p == null) return false;
    if (salt?.isNotEmpty == true) {
      key = key + salt!;
    }
    if (value is bool) {
      return p.setBool(key, value);
    } else if (value is int) {
      return p.setInt(key, value);
    } else if (value is double) {
      return p.setDouble(key, value);
    } else if (value is String) {
      return p.setString(key, value);
    } else if (value is List<String> || value is List) {
      return p.setStringList(key, List<String>.from(value));
    }
    return false;
  }
}
