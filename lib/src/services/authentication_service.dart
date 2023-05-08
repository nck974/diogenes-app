import 'package:logger/logger.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

import 'package:diogenes/src/exceptions/authorization_exception.dart';

class AuthenticationService {
  static String authenticationPath =
      '/keycloak/realms/diogenes/protocol/openid-connect/token';
  final String authorizationEndpoint;
  final String backendUrl;
  final String identifier = 'diogenes-client';
  final String secret = '';
  final logger = Logger();

  AuthenticationService({required this.backendUrl})
      : authorizationEndpoint = "$backendUrl$authenticationPath";

  Future<oauth2.Credentials> authenticate(
      String username, String password) async {
    logger.d('Sending request to authenticate "$username"');
    try {
      final client = await oauth2.resourceOwnerPasswordGrant(
        Uri.parse(authorizationEndpoint), // TODO: Use backend URL
        username,
        password,
        identifier: identifier,
        secret: secret,
      );
      return client.credentials;
    } on oauth2.AuthorizationException catch (e) {
      logger.e('AuthorizationException: ${e.description}');
      throw AuthorizationException();
    } catch (e) {
      logger.e('Error during authentication: $e');
      throw AuthorizationException();
    }
  }
}
