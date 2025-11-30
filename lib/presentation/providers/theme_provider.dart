import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  static const String themeBoxName = 'app_settings';
  static const String themeKey = 'theme_mode';
  
  @override
  ThemeMode build() {
    // Initialize with the saved theme or system default
    // Use late to defer initialization until needed
    late final ThemeMode themeMode;
    try {
      final box = Hive.box(themeBoxName);
      final savedThemeIndex = box.get(themeKey, defaultValue: 0);
      themeMode = ThemeMode.values[savedThemeIndex];
    } catch (e) {
      // Fallback to system if there's any issue
      themeMode = ThemeMode.system;
    }
    return themeMode;
  }
  
  void toggleTheme() {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = newTheme;
    
    // Save the theme preference
    final box = Hive.box(themeBoxName);
    box.put(themeKey, newTheme.index);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  () => ThemeNotifier(),
);
