import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:diogenes/src/providers/settings_provider.dart';
import 'package:diogenes/src/providers/inventory_provider.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatefulWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _formKey = GlobalKey<FormState>();

  bool _displaySaveButton = false;
  String? _currentBackendUrl;
  final TextEditingController _backendUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _backendUrlController.text = widget.controller.backendUrl;
  }

  /// Select box that selects the language
  DropdownButton<ThemeMode> _displayThemeSettings(
      AppLocalizations translations) {
    return DropdownButton<ThemeMode>(
      // Read the selected themeMode from the controller
      value: widget.controller.themeMode,
      // Call the updateThemeMode method any time the user selects a theme.
      onChanged: widget.controller.updateThemeMode,
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
      value: widget.controller.locale,
      // Call the updateThemeMode method any time the user selects a theme.
      onChanged: widget.controller.updateLocale,
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

  /// If the backend URL is different than the settings value already stored
  /// a button to save the new setting will be displayed
  void _onBackendUrlChange(String value) {
    if (value.isEmpty || value == _currentBackendUrl) {
      if (_displaySaveButton != false) {
        setState(() {
          _displaySaveButton = false;
        });
      }
    } else {
      if (_displaySaveButton != true) {
        setState(() {
          _displaySaveButton = true;
        });
      }
    }
  }

  /// Show the text to configure the backend server. If it is changed a button
  /// to save will be displayed
  Widget _displayServerUrl(AppLocalizations translations) {
    return TextFormField(
      controller: _backendUrlController,
      decoration: InputDecoration(
        hintText: translations.settingsBackendUrl,
      ),
      onChanged: _onBackendUrlChange,
      validator: (value) {
        if (value == null) {
          return translations.settingsValidationNoUrl;
        }
        return Uri.tryParse(value)!.isAbsolute
            ? null
            : translations.settingsValidationInvalidPath;
      },
    );
  }

  /// Save the changed settings
  void _onSaveSettings() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // Backend url
      final newBackendUrl = _backendUrlController.text;
      widget.controller.updateBackendUrl(newBackendUrl);
      setState(() {
        _currentBackendUrl = newBackendUrl;
        _displaySaveButton = false;
        // Update provider for current run
        Provider.of<InventoryProvider>(context, listen: false).backendUrl =
            newBackendUrl;
      });
    }
  }

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
            Form(
              key: _formKey,
              child: _displayServerUrl(translations),
            )
          ],
        ),
      ),
      floatingActionButton: _displaySaveButton
          ? FloatingActionButton(
              onPressed: _onSaveSettings,
              child: const Icon(Icons.save),
            )
          : null,
    );
  }
}
