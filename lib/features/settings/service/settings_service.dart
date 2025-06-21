import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final supportedLocales = const [
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
    Locale('gu'),
  ];

  final localeLabels = const {
    'en': 'English',
    'hi': 'हिन्दी',
    'mr': 'मराठी',
    'gu': 'ગુજરાતી',
  };

  List<DropdownMenuItem<Locale>> buildLocaleDropdownItems(Locale selected) {
    final List<Locale> ordered = [
      selected,
      ...supportedLocales.where((l) => l != selected),
    ];
    final seen = <String>{};
    final uniqueOrdered = ordered
        .where((l) => seen.add(l.languageCode))
        .toList();
    return uniqueOrdered.map((locale) {
      return DropdownMenuItem(
        value: locale,
        child: Text(localeLabels[locale.languageCode] ?? locale.languageCode),
      );
    }).toList();
  }

  Future<void> changeLanguage(
    Locale locale,
    ValueChanged<Locale>? onLocaleChanged,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    if (onLocaleChanged != null) onLocaleChanged(locale);
  }
}
