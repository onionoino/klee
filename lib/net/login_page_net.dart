/// Provide the model layer of login page, including net IO operations authenticate and get authentication information
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
import 'package:securedialog/utils/constants.dart';
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
