import 'package:flutter/material.dart';

import 'package:oauth2/oauth2.dart' as oauth2;

import 'package:diogenes/src/services/settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  SettingsController(this._settingsService);

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;
  late Locale _locale;
  late String _backendUrl;
  oauth2.Credentials? _credentials;

  // Allow Widgets to read the settings.
  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  String get backendUrl => _backendUrl;
  oauth2.Credentials? get credentials => _credentials;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _locale = await _settingsService.locale();
    _backendUrl = await _settingsService.backendUrl();
    _credentials = await _settingsService.credentials();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateLocale(Locale? newLocale) async {
    if (newLocale == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newLocale == _locale) return;

    // Otherwise, store the new ThemeMode in memory
    _locale = newLocale;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateLocale(newLocale);
  }

  /// Update and persist the backendUrl provided by the user.
  Future<void> updateBackendUrl(String? backendUrl) async {
    if (backendUrl == null) return;

    // Do not perform any work if new and old backendUrl are identical
    if (_backendUrl == backendUrl) return;

    // Otherwise, store the new ThemeMode in memory
    _backendUrl = backendUrl;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateBackendUrl(backendUrl);
  }

  /// Update and persist the access token
  Future<void> updateCredentials(oauth2.Credentials credentials) async {
    if (_credentials == credentials) return;

    _credentials = credentials;

    notifyListeners();

    await _settingsService.updateCredentials(credentials);
  }

  /// Update and persist the access token
  Future<void> removeCredentials() async {
    _credentials = null;

    notifyListeners();

    await _settingsService.removeCredentials();
  }
}
