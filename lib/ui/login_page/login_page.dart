/// The widget for displaying LOGIN page
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:securedialog/ui/key_page/key_page.dart';
import 'package:securedialog/utils/base_widget.dart';
import 'package:securedialog/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service/login_page_service.dart';
import 'login_image.dart';

/// the view layer of login page
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController webIdController = TextEditingController();
  final LoginPageService loginPageService = LoginPageService();

  _load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastInputURL = prefs.getString(Constants.lastInputURLKey);
    if (lastInputURL != null && lastInputURL != Constants.none) {
      webIdController = TextEditingController()..text = lastInputURL;
    }
  }

  Future<void> _showErrorDialog(String message) async {
    print("Trying to show dialog");  // Debug print
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Oops!',
            style: TextStyle(fontSize: 24, color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    message,
                  style: const TextStyle(fontFamily: 'KleeOne', fontSize: 18, color: Colors.black),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                  'OK',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration.zero,
        () => setState(() {
              _load();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseWidget.getAppBar("SecureDiaLog"),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            BaseWidget.getPadding(25.0),
            const LoginImage(),
            BaseWidget.getPadding(10.0),
            RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (event) async {
                if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                  try{
                    if (!loginPageService.loginPreCheck(webIdController.text)) {
                      await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return BaseWidget.getNoticeDialog(context, "Warning",
                                "You gave an invalid webId", "Try again");
                          });
                      return;
                    }
                    if (!mounted) {
                      return;
                    }
                    Map<dynamic, dynamic>? authData;
                    await loginPageService
                        .loginAndAuth(webIdController.text, context, mounted)
                        .then((result) {
                      authData = result;
                    }).catchError((error) {
                      print("Caught error: $error");
                      _showErrorDialog("The server may be down. \nPlease Try again later.");
                    });
                    // Map<dynamic, dynamic>? authData = await loginPageService
                    //     .loginAndAuth(webIdController.text, context, mounted);
                    if (!mounted) {
                      return;
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => KeyPage(authData)),
                    );
                  } catch (e) {
                    print("Exception caught: $e");
                    _showErrorDialog("The server may be down. \nPlease Try again later.");
                  }
                }
              },
              child: TextField(
                controller: webIdController,
                style: const TextStyle(fontSize: 20, fontFamily: "KleeOne"),
                textAlign: TextAlign.center,
                autofocus: false,
                decoration: const InputDecoration(
                  hintText:
                      "https://pod-url.example-server.net/profile/card#me",
                ),
                onSubmitted: (value) async {
                  if (!loginPageService.loginPreCheck(webIdController.text)) {
                    await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return BaseWidget.getNoticeDialog(context, "Warning",
                              "You gave an invalid webId", "Try again");
                        });
                    return;
                  }
                  if (!mounted) {
                    return;
                  }
                  Map<dynamic, dynamic>? authData = await loginPageService
                      .loginAndAuth(webIdController.text, context, mounted);
                  if (!mounted) {
                    return;
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => KeyPage(authData)),
                  );
                },
              ),
            ),
            BaseWidget.getPadding(20.0),
            BaseWidget.getElevatedButton(() async {
              try{
                if (!loginPageService.loginPreCheck(webIdController.text)) {
                  await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return BaseWidget.getNoticeDialog(context, "Warning",
                            "You gave an invalid webId", "Try again");
                      });
                  return;
                }
                Map<dynamic, dynamic>? authData = await loginPageService
                    .loginAndAuth(webIdController.text, context, mounted);

                  if (!mounted) {
                    return null;
                  }

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KeyPage(authData),
                  ),
                );
              } catch (e) {
                print("Exception caught: $e");
                _showErrorDialog("The server may be down. \nPlease try again later.");
              }
            }, "Login", MediaQuery.of(context).size.width / 1.25, 50),
            BaseWidget.getPadding(150.0),
          ],
        ),
      ),
      backgroundColor: Colors.orange[50],
    );
  }
}
