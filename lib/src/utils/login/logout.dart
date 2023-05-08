import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:diogenes/src/core/login/login_screen.dart';
import 'package:diogenes/src/providers/authentication_provider.dart';
import 'package:diogenes/src/providers/settings_provider.dart';

/// Go back to login removing all credentials stored
Future<void> logout(BuildContext context) async {
  final navigator = Navigator.of(context);
  Provider.of<AuthenticationProvider>(context, listen: false).logout();
  await Provider.of<SettingsController>(context, listen: false)
      .removeCredentials();
  navigator.pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
}
