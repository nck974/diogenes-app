import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:diogenes/src/core/add_item/add_item_screen.dart';
import 'package:diogenes/src/core/inventory/inventory_screen.dart';
import 'package:diogenes/src/core/item_detail/item_detail_screen.dart';
import 'package:diogenes/src/core/settings/settings_screen.dart';
import 'package:diogenes/src/core/login/login_screen.dart';

import 'package:diogenes/src/models/item.dart';

import 'package:diogenes/src/providers/inventory_provider.dart';
import 'package:diogenes/src/providers/authentication_provider.dart';
import 'package:diogenes/src/providers/settings_provider.dart';

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

          case InventoryScreen.routeName:
            return const InventoryScreen();
          default:
            return const LoginScreen();
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
            ChangeNotifierProvider(
              create: (_) => settingsController,
            ),
            ChangeNotifierProvider(
              create: (_) => AuthenticationProvider(
                  backendUrl: settingsController.backendUrl),
            ),
            ChangeNotifierProvider(
              create: (context) {
                final authenticationProvider =
                    Provider.of<AuthenticationProvider>(context, listen: false);
                return InventoryProvider(
                    authenticationProvider: authenticationProvider,
                    backendUrl: settingsController.backendUrl);
              },
            ),
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
            locale: settingsController.locale,

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
            theme: ThemeData(useMaterial3: true),
            darkTheme: ThemeData.dark().copyWith(useMaterial3: true),
            themeMode: settingsController.themeMode,

            // Set first page
            initialRoute: '/',
            routes: {
              '/': (context) => const LoginScreen(),
            },

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            onGenerateRoute: onGenerateRoute,
          ),
        );
      },
    );
  }
}
