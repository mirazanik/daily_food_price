import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String _themeKey = 'theme_mode';

  // Observable theme mode
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  // Load saved theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);

    if (savedTheme != null) {
      themeMode.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    } else {
      // Default to system theme
      themeMode.value = ThemeMode.system;
    }
  }

  // Toggle between light and dark theme
  Future<void> toggleTheme() async {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
      await _saveThemeMode('dark');
    } else {
      themeMode.value = ThemeMode.light;
      await _saveThemeMode('light');
    }
  }

  // Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    if (mode == ThemeMode.dark) {
      await _saveThemeMode('dark');
    } else if (mode == ThemeMode.light) {
      await _saveThemeMode('light');
    } else {
      await _saveThemeMode('system');
    }
  }

  // Save theme mode to SharedPreferences
  Future<void> _saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode);
  }

  // Check if current theme is dark
  bool get isDarkMode {
    if (themeMode.value == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return themeMode.value == ThemeMode.dark;
  }
}
