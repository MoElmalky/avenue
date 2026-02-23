import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  final SharedPreferences _prefs;

  CacheHelper(this._prefs);

  /// Saves a value to cache with the given [key].
  /// Supports [String], [int], [bool], [double], and [List<String>].
  Future<bool> setData({required String key, required dynamic value}) async {
    if (value is String) return await _prefs.setString(key, value);
    if (value is int) return await _prefs.setInt(key, value);
    if (value is bool) return await _prefs.setBool(key, value);
    if (value is double) return await _prefs.setDouble(key, value);
    if (value is List<String>) return await _prefs.setStringList(key, value);
    return false;
  }

  /// Retrieves a value from cache for the given [key].
  dynamic getData({required String key}) {
    return _prefs.get(key);
  }

  /// Removes a value from cache for the given [key].
  Future<bool> removeData({required String key}) async {
    return await _prefs.remove(key);
  }

  /// Clears all data from cache.
  Future<bool> clearData() async {
    return await _prefs.clear();
  }

  /// Checks if a [key] exists in cache.
  bool containsKey({required String key}) {
    return _prefs.containsKey(key);
  }
}
