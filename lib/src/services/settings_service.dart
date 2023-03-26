import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  static const _defaultBackendURL = 'http://10.0.2.2:8080';

  static const _themeModeProperty = 'settings.theme.themeMode';
  static const _backendUrlProperty = 'settings.backendServer.url';
  static const _localeProperty = 'settings.locale.language';

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

  /// Persists the property in the memory shared preferences.
  Future<void> _updateSharedProperty(String property, dynamic value) async {
    _logger.d("Saving in '$property' value: ${value.toString()}");
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(property, value.toString());
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    _updateSharedProperty(_themeModeProperty, theme);
  }

  /// Loads the User's local.
  Future<Locale> locale() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? locale = preferences.getString(_localeProperty);
    if (locale != null) {
      if (locale == const Locale.fromSubtags(languageCode: "en").toString()) {
        _logger.d("English locale found the settings");
        return const Locale.fromSubtags(languageCode: "en");
      } else if (locale ==
          const Locale.fromSubtags(languageCode: "es").toString()) {
        _logger.d("Spanish locale found the settings");
        return const Locale.fromSubtags(languageCode: "es");
      } else {
        _logger.d("Invalid locale found in the settings $locale");
      }
    }

    /// Try to obtain the default locale of the system if is in the available
    /// languages
    var systemLocale = Platform.localeName;
    if (systemLocale.isNotEmpty) {
      if (systemLocale.length > 2) {
        systemLocale = systemLocale.split("_")[0];
      }
      if (["en", "de"].contains(systemLocale)) {
        return Locale.fromSubtags(languageCode: systemLocale);
      }
    }

    return const Locale.fromSubtags(languageCode: "en");
  }

  /// Persists the user's preferred locale to local or remote storage.
  Future<void> updateLocale(Locale locale) async {
    _updateSharedProperty(_localeProperty, locale);
  }

  /// Loads the  backendUrl.
  Future<String> backendUrl() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? url = preferences.getString(_backendUrlProperty);
    if (url != null) {
      _logger.d("URL found in settings $url");
      return url;
    }
    _logger
        .d("URL not found in settings. Using default url: $_defaultBackendURL");

    return _defaultBackendURL;
  }

  /// Persists the user's backendUrl to local or remote storage.
  Future<void> updateBackendUrl(String backendUrl) async {
    _updateSharedProperty(_backendUrlProperty, backendUrl);
  }
}
