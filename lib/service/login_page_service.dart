import 'package:flutter/cupertino.dart';
import 'package:klee/net/login_page_net.dart';
import 'package:klee/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// the model-view layer of login page, including all services the very view layer needs
class LoginPageService {
  final LoginPageNet loginPageNet = LoginPageNet();

  /// before doing login procedure, roughly check the link the user give,
  /// if it is obviously not a valid webId, an error message will be given, this is not an accurate check
  /// @param webId - the webId users gave in the input box in login page
  /// @return isValid - TRUE means passing the check and FALSE means it is not a valid webId string
  bool loginPreCheck(String webId) {
    return Constants.urlRegExp.hasMatch(webId);
  }

  /// login service used in view layer of login page
  /// @param webId - user's webId
  ///        context - the context of login widget
  ///        mounted - to eliminate the warning from a async method
  /// @return authData - a map that contains all information after authentication, including accessToken and dPopToken
  Future<Map<dynamic, dynamic>?> loginAndAuth(
      String webId, BuildContext context, bool mounted) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!mounted) {
      return null;
    }
    String? lastInputURL = prefs.getString(Constants.lastInputURLKey);
    if (lastInputURL != webId) {
      prefs.setString(Constants.lastScheduledDateKey, Constants.none);
    }
    prefs.setString(Constants.lastInputURLKey, webId);
    try {
      return await loginPageNet.getAuthData(webId, context, mounted);
    } catch (e) {
      // Propagate the error to be caught in the view layer
      throw e;
    }
  }
}
