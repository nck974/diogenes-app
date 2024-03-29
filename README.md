# DiogenesApp

An app to manage your home inventory implemented in flutter.

## Features

1. List inventory.
1. Check item details.
1. Add, edit and delete items.
1. Dark and light theme.
1. Internationalized. Currently available in languages (Can be extended if `.arb` translation is provided):
    ```
    English, Spanish
    ```
1. Sort items.
1. Filter items.
1. Oauth2 authentication using keycloak

# Development

## Localization

This project generates localized messages based on arb files found in
the `lib/src/localization` directory.

To support additional languages, please visit the tutorial on
[Internationalizing Flutter
apps](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)

Every time some `.arb` is modified the app needs to be restarted (Not hot reload).

In order to use the translations be sure to import first:
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Then call:
AppLocalizations.of(context)!.propertyNameInTheJson;