import 'package:hive/hive.dart';

/// Hive-based service for storing app settings
class HiveSettingsService {
  static const String _boxName = 'app_settings';
  static const String _darkModeKey = 'darkMode';
  static const String _localeKey = 'locale';

  static Box? _settingsBox;

  /// Initialize the settings box
  static Future<void> init() async {
    _settingsBox = await Hive.openBox(_boxName);
  }

  /// Get the settings box
  static Box get _box {
    if (_settingsBox?.isOpen == true) {
      return _settingsBox!;
    }
    throw Exception(
      'Settings box not initialized. Call HiveSettingsService.init() first.',
    );
  }

  /// Get dark mode setting
  static bool get isDarkMode => _box.get(_darkModeKey, defaultValue: false);

  /// Set dark mode setting
  static Future<void> setDarkMode(bool value) async {
    await _box.put(_darkModeKey, value);
  }

  /// Get locale setting
  static String get locale => _box.get(_localeKey, defaultValue: 'en');

  /// Set locale setting
  static Future<void> setLocale(String languageCode) async {
    await _box.put(_localeKey, languageCode);
  }

  /// Clear all settings
  static Future<void> clearAll() async {
    await _box.clear();
  }

  /// Close the settings box
  static Future<void> close() async {
    await _settingsBox?.close();
  }
}
