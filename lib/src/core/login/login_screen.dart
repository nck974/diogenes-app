import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:diogenes/src/core/inventory/inventory_screen.dart';
import 'package:diogenes/src/exceptions/authorization_exception.dart';
import 'package:diogenes/src/models/login_data.dart';
import 'package:diogenes/src/providers/settings_provider.dart';
import 'package:diogenes/src/providers/authentication_provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AppLocalizations _translations;
  String? _errorMessage;

  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _autoLogin();
    _translations = AppLocalizations.of(context)!;
  }

  /// If the credentials are available (therefore not expired), save the
  /// credentials in the provider and try directly to go to the inventory
  void _autoLogin() {
    final credentials =
        Provider.of<SettingsController>(context, listen: false).credentials;
    if (credentials != null) {
      Provider.of<AuthenticationProvider>(context, listen: false).credentials =
          credentials;
      Future.delayed(const Duration(seconds: 0)).then((_) =>
          Navigator.of(context).pushNamedAndRemoveUntil(
              InventoryScreen.routeName, (route) => false));
    }
  }

  /// Delete the error messages to show change in the UI if error happens again
  void _clearErrorMessages() {
    setState(() {
      _errorMessage = null;
    });
  }

  /// Send the request to login, if an error is present show it in the UI
  void _onLogin(AuthenticationProvider authenticationProvider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    var username = _usernameController.text;
    var password = _passwordController.text;
    _clearErrorMessages();
    try {
      await authenticationProvider
          .authenticate(LoginData(user: username, password: password));
      if (!mounted) return;
      await Provider.of<SettingsController>(context, listen: false)
          .updateCredentials(authenticationProvider.credentials!);
      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(InventoryScreen.routeName);
    } on AuthorizationException {
      setState(() {
        _errorMessage = _translations.loginErrorLogin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AuthenticationProvider>(
            builder: (ctx, authenticationProvider, _) {
          return Form(
            key: _formKey,
            child: authenticationProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: _translations.loginUsername,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: _translations.loginPassword,
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () => _onLogin(authenticationProvider),
                        child: Text(_translations.loginLoginButton),
                      ),
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.red),
                        )
                    ],
                  ),
          );
        }),
      ),
    );
  }
}
