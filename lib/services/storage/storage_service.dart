import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_keys.dart';

class StorageService extends GetxService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  void setBool(String key, bool value) {
    _prefs?.setBool(key, value);
  }

  bool? getBool(String key) {
    bool? result = _prefs?.getBool(key);
    return result;
  }

  bool getBoolOrFalse(String key) {
    bool? result = _prefs?.getBool(key);
    return result ?? false;
  }

  void setInt(String key, int value) {
    _prefs?.setInt(key, value);
  }

  int? getInt(String key) {
    int? result = _prefs?.getInt(key);
    return result;
  }

  void setString(String key, String value) {
    _prefs?.setString(key, value);
  }

  String? getString(String key) {
    String? result = _prefs?.getString(key);
    return result;
  }

  void setMap(String key, Map<String, dynamic> value) {
    _prefs?.setString(key, json.encode(value));
  }

  Map<String, dynamic>? getMap(String key) {
    String? mapString = _prefs?.getString(key);
    if (mapString != null) {
      return json.decode(mapString);
    } else {
      return null;
    }
  }

  void removeKey(String key) {
    _prefs?.remove(key);
  }

  /// Clear all storage keys
  Future<void> clear() async {
    _prefs?.clear().then((value) => Get.defaultDialog(middleText: 'Prefs cleared'));
  }
}
