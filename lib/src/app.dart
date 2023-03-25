import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:diogenes/src/add_item/add_item_screen.dart';
import 'package:diogenes/src/inventory/inventory_screen.dart';
import 'package:diogenes/src/item_detail/item_detail_screen.dart';
import 'package:diogenes/src/models/item.dart';
import 'package:diogenes/src/providers/inventory_provider.dart';

import 'package:diogenes/src/settings/settings_controller.dart';
import 'package:diogenes/src/settings/settings_view.dart';

/// The Widget that configures the application.
class Diogenes extends StatelessWidget {
  final SettingsController settingsController;

  const Diogenes({
    super.key,
    required this.settingsController,
  });

  /// Manage the app routes
  Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    return MaterialPageRoute<void>(
      settings: routeSettings,
      builder: (BuildContext context) {
        switch (routeSettings.name) {
          case SettingsView.routeName:
            return SettingsView(controller: settingsController);

          case ItemDetailScreen.routeName:
            // Extract the Item object from the arguments property of the RouteSettings object.
            final item = routeSettings.arguments as Item;
            return ItemDetailScreen(item: item);

          case AddItemScreen.routeName:
            // Extract the Item object optionally from the arguments property of the RouteSettings object.
            final item = routeSettings.arguments as Item?;
            return AddItemScreen(item: item);

          default:
            return const InventoryScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => InventoryProvider()),
          ],
          child: MaterialApp(
            // Providers

            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
              Locale('es', ''), // Spanish, no country code
            ],

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,

            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme: ThemeData(),
            darkTheme: ThemeData.dark(),
            themeMode: settingsController.themeMode,

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            onGenerateRoute: onGenerateRoute,
          ),
        );
      },
    );
  }
}
