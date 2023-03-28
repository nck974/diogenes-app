import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:diogenes/src/core/settings/settings_screen.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return PopupMenuButton(itemBuilder: (context) {
      return [
        PopupMenuItem<int>(
          value: 0,
          enabled: false,
          child: Text(translations.inventoryMenuCategories),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Text(translations.inventoryMenuSettings),
        ),
        PopupMenuItem<int>(
          value: 2,
          enabled: false,
          child: Text(translations.inventoryMenuLogout),
        ),
      ];
    }, onSelected: (value) {
      if (value == 0) {
        print("Categories is selected. TODO"); // TODO
      } else if (value == 1) {
        // Navigate to the settings page. If the user leaves and returns
        // to the app after it has been killed while running in the
        // background, the navigation stack is restored.
        Navigator.restorablePushNamed(context, SettingsView.routeName);
      } else if (value == 2) {
        print("Logout menu is selected.");
      }
    });
  }
}
