import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  static const _themeModeProperty = 'settings.theme.themeMode';
  final _logger = Logger();

  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? themeMode = preferences.getString(_themeModeProperty);
    if (themeMode != null) {
      if (themeMode == ThemeMode.dark.toString()) {
        _logger.d("Dark theme mode found the settings");
        return ThemeMode.dark;
      } else if (themeMode == ThemeMode.light.toString()) {
        _logger.d("Light theme mode found the settings");
        return ThemeMode.light;
      } else {
        _logger.d("Invalid theme found in the settings $themeMode");
      }
    }
    return ThemeMode.system;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    _logger.d("Saving in '$_themeModeProperty' value: ${theme.toString()}");
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(_themeModeProperty, theme.toString());
  }
}
