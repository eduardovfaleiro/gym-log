import 'package:hive_flutter/hive_flutter.dart';

abstract class Config {
  static final _box = Hive.box('config');

  static int getInt(String key, {int defaultValue = 0}) {
    return _box.get(key) ?? defaultValue;
  }

  static Future<void> setInt(String key, int value) async {
    await _box.put(key, value);
  }

  static String getString(String key, {String defaultValue = ''}) {
    return _box.get(key) ?? defaultValue;
  }

  static Future<void> setString(String key, String value) async {
    await _box.put(key, value);
  }
}
