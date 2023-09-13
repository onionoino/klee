import 'package:flutter/cupertino.dart';
import 'package:klee/utils/constants.dart';
import 'package:solid_auth/solid_auth.dart';

/// model layer of login page, including net IO operations authenticate and get authentication information
class LoginPageNet {
  /// get authentication data
  /// @param webId - user's webId
  ///        context - the context of login widget
  ///        mounted - to eliminate the warning from a async method
  /// @return authData - a map that contains all information after authentication, -including accessToken and dPopToken
  Future<Map?> getAuthData(
      String webId, BuildContext context, bool mounted) async {
    try {
      String issuerUri = await getIssuer(webId);
      if (!mounted) {
        return null;
      }
      return authenticate(Uri.parse(issuerUri), Constants.scopes, context);
    } catch (e) {
      print("Caught exception: $e");
      // Handle the exception, maybe return a specific error Map or null
      throw Exception("$e");
    }
  }
}
