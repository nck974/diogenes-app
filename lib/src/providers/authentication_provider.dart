import 'package:flutter/material.dart';

import 'package:oauth2/oauth2.dart' as oauth2;

import 'package:diogenes/src/models/login_data.dart';
import 'package:diogenes/src/services/authentication_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  String _backendUrl;
  bool _isLoading = false;
  oauth2.Credentials? _credentials;

  AuthenticationProvider({required backendUrl}) : _backendUrl = backendUrl;

  bool get isLoading => _isLoading;
  oauth2.Credentials? get credentials => _credentials;
  set credentials(credentials) => _credentials = credentials;

  /// Update
  set backendUrl(String backendUrl) {
    _backendUrl = backendUrl;
  }

  /// Notify listeners that the request is loading
  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  /// Notify listeners that the request is not loading anymore
  void _endLoading() {
    _isLoading = false;
    notifyListeners();
  }

  /// Authenticate a User and show a loading icon while it is doing it
  Future<void> authenticate(LoginData user) async {
    _startLoading();
    try {
      _credentials = await AuthenticationService(backendUrl: _backendUrl)
          .authenticate(user.user, user.password);
      _endLoading();
    } catch (_) {
      _endLoading();
      rethrow;
    }
  }

  /// Remove the current credentials
  void logout() {
    _credentials = null;
    notifyListeners();
  }
}
