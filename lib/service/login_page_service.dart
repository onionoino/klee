/// Handle the POD login to the SOLID server.
///
/// Copyright (C) 2023 The Authors
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Bowen Yang, Ye Duan

import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:klee/net/login_page_net.dart';
import 'package:klee/utils/constants.dart';

/// A model-view layer of the login page, including all services the very view
/// layer needs.

class LoginPageService {
  final LoginPageNet loginPageNet = LoginPageNet();

  /// Before doing login procedure, roughly check the link the user give, if it
  /// is obviously not a valid webId, an error message will be given, this is
  /// not an accurate check. The supplied [webId] is the input box in login page
  /// [isValid] - TRUE means passing the check and FALSE means it is not a valid
  /// webId string

  bool loginPreCheck(String webId) {
    return Constants.urlRegExp.hasMatch(webId);
  }

  /// A login service used in the view layer of the login page with [webId] as
  /// the user's webId context - the context of login widget mounted - to
  /// eliminate the warning from a async method @return authData - a map that
  /// contains all information after authentication, including accessToken and
  /// dPopToken

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
      // Propagate the error to be caught in the view layer.
      throw e;
    }
  }
}
