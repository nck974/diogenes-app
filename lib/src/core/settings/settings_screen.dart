import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:diogenes/src/providers/settings_provider.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    AppLocalizations translations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(translations.settingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: Column(
          children: [
            _displayThemeSettings(translations),
            _displayLocaleSettings(translations),
          ],
        ),
      ),
    );
  }

  /// Select box that selects the language
  DropdownButton<ThemeMode> _displayThemeSettings(
      AppLocalizations translations) {
    return DropdownButton<ThemeMode>(
      // Read the selected themeMode from the controller
      value: controller.themeMode,
      // Call the updateThemeMode method any time the user selects a theme.
      onChanged: controller.updateThemeMode,
      items: [
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Text(translations.settingsTitleThemeOptionSystem),
        ),
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Text(translations.settingsTitleThemeOptionLight),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Text(translations.settingsTitleThemeOptionDark),
        )
      ],
    );
  }

  /// Select box that selects the language
  DropdownButton<Locale> _displayLocaleSettings(AppLocalizations translations) {
    return DropdownButton<Locale>(
      // Read the selected themeMode from the controller
      value: controller.locale,
      // Call the updateThemeMode method any time the user selects a theme.
      onChanged: controller.updateLocale,
      items: [
        DropdownMenuItem(
          value: const Locale.fromSubtags(languageCode: 'en'),
          child: Text(translations.settingsLanguageOptionEnglish),
        ),
        DropdownMenuItem(
          value: const Locale.fromSubtags(languageCode: 'es'),
          child: Text(translations.settingsLanguageOptionSpanish),
        ),
      ],
    );
  }
}
