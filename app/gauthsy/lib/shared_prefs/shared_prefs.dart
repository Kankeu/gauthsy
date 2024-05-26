library shared_prefs;

import 'dart:convert';

import 'package:gauthsy/kernel/container/container.dart';
import 'package:gauthsy/kernel/event_manager/event_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  final SharedPreferences _prefs;
  static final em =
      Container().has("em") ? Container().get<EventManager>("em") : null;

  SharedPrefs(this._prefs);

  static Future init() async {
    final prefs = await SharedPreferences.getInstance();
    Container().set("prefs", () => SharedPrefs(prefs));
    if (em == null) return;
    em.signal("authenficate");
  }

  String getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  int getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  bool getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  Map<String, dynamic> getJson(String key) {
    try {
      return jsonDecode(_prefs.getString(key));
    } catch (e) {
      return null;
    }
  }

  Future<bool> setJson(String key, Map<String, dynamic> value) {
    return _prefs.setString(key, jsonEncode(value));
  }

  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  Future<bool> clear() {
    return _prefs.clear();
  }
}
