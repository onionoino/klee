/// Provide the service layer of key page for managing the encryption key
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
/// Authors: Bowen Yang

import '../utils/constants.dart';
import '../utils/encrpt_utils.dart';
import '../utils/solid_utils.dart';

class KeyPageService {
  Future<bool> checkAndSetEncKey(
      Map<dynamic, dynamic>? authData, String encKeyText) async {
    Map<String, dynamic> podInfo = SolidUtils.parseAuthData(authData);
    String? webId = podInfo[Constants.webId];
    return EncryptUtils.checkAndSet(authData!, encKeyText, webId!);
  }
}
