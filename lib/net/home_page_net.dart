/// Provide the model layer of home page, including basic CRUD HTTPS connections to a specific POD
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

import 'package:http/http.dart';
import 'package:securedialog/utils/constants.dart';
import 'package:solid_auth/solid_auth.dart';
import 'package:url_launcher/url_launcher.dart';


/// model layer of home page, including basic CRUD HTTPS connections to a specific POD
class HomePageNet {
  /// this method is to read a file
  /// @param fileURI - the uri of a file users would like to read in a pod
  ///        accessToken - the access token parsed from authentication data after login
  ///        rsa - rsaKeyPair to help generate dPopToken
  ///        pubKeyJwk - pubKeyJwk to help generate dPopToken
  /// @return content - all content fetched from the POD as a String
  Future<String> readFile(String fileURI, String accessToken,
      dynamic rsaKeyPair, dynamic publicKeyJwk) async {
    String dPopToken = genDpopToken(fileURI, rsaKeyPair, publicKeyJwk, "GET");
    Response response = await get(
      Uri.parse(fileURI),
      headers: <String, String>{
        "Accept": "*/*",
        "Authorization": "DPoP $accessToken",
        "Connection": "keep-alive",
        "DPoP": dPopToken,
      },
    );
    if (response.statusCode == Constants.ok) {
      return response.body;
    } else {
      throw Exception("Error on reading a file");
    }
  }

  /// this method is to update a file
  /// @param fileURI - the uri of a file users would like to read in a pod
  ///        accessToken - the access token parsed from authentication data after login
  ///        rsa - rsaKeyPair to help generate dPopToken
  ///        pubKeyJwk - pubKeyJwk to help generate dPopToken
  ///        query - the sparql query to edit the specific file
  /// @return void
  Future<void> updateFile(String fileURI, String accessToken,
      dynamic rsaKeyPair, dynamic publicKeyJwk, String query) async {
    String dPopToken = genDpopToken(fileURI, rsaKeyPair, publicKeyJwk, "PATCH");
    Response response = await patch(
      Uri.parse(fileURI),
      headers: <String, String>{
        "Accept": "*/*",
        "Authorization": "DPoP $accessToken",
        "Connection": "keep-alive",
        "Content-Type": "application/sparql-update",
        "Content-Length": query.length.toString(),
        "DPoP": dPopToken,
      },
      body: query,
    );
    if (response.statusCode != Constants.ok &&
        response.statusCode != Constants.reset) {
      throw Exception("Error on updating a file");
    }
  }

  /// this method is to create a new container in the root directory of a POD
  /// @param rootURI - the uri of a root directory of a POD
  ///        accessToken - the access token parsed from authentication data after login
  ///        rsa - rsaKeyPair to help generate dPopToken
  ///        pubKeyJwk - pubKeyJwk to help generate dPopToken
  ///        containerName - the name of your new container (folder)
  /// @return void
  Future<void> mkdir(String rootURI, String accessToken, dynamic rsaKeyPair,
      dynamic publicKeyJwk, String containerName) async {
    String dPopToken = genDpopToken(rootURI, rsaKeyPair, publicKeyJwk, "POST");
    Response response = await post(
      Uri.parse(rootURI),
      headers: <String, String>{
        "Accept": "*/*",
        "Authorization": "DPoP $accessToken",
        "Connection": "keep-alive",
        "Content-Type": "text/turtle",
        "DPoP": dPopToken,
        "Link": "<http://www.w3.org/ns/ldp#BasicContainer>; rel=\"type\"",
        "Slug": containerName,
      },
    );
    if (response.statusCode != Constants.created) {
      throw Exception("Error on creating a directory");
    }
  }

  /// this method is to create a new file in the root directory of a POD
  /// @param containerURI - the uri of a container you would like to create your file in
  ///        accessToken - the access token parsed from authentication data after login
  ///        rsa - rsaKeyPair to help generate dPopToken
  ///        pubKeyJwk - pubKeyJwk to help generate dPopToken
  ///        fileName - the name of your new file
  /// @return void
  Future<void> touch(String containerURI, String accessToken,
      dynamic rsaKeyPair, dynamic pubKeyJwk, String fileName) async {
    String dPopToken =
        genDpopToken(containerURI, rsaKeyPair, pubKeyJwk, "POST");
    Response response = await post(
      Uri.parse(containerURI),
      headers: <String, String>{
        "Accept": "*/*",
        "Authorization": "DPoP $accessToken",
        "Connection": "keep-alive",
        "Content-Type": "text/turtle",
        "DPoP": dPopToken,
        "Link": "<http://www.w3.org/ns/ldp#Resource>; rel=\"type\"",
        "Slug": fileName,
      },
    );
    if (response.statusCode != Constants.created) {
      throw Exception("Error on creating a file");
    }
  }

  /// this method is to log current user out in a web view
  /// @param logoutURL - the url that can logout a user in a browser
  /// @return void
  void logout(String logoutUrl) async {
    if (await canLaunchUrl(Uri.parse(logoutUrl))) {
      await launchUrl(Uri.parse(logoutUrl));
    } else {
      throw Exception("Could not launch $logoutUrl");
    }
    await Future.delayed(const Duration(seconds: 2));
    closeInAppWebView();
  }
}
