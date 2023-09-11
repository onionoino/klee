import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klee/ui/key_page/key_page.dart';
import 'package:klee/utils/base_widget.dart';
import 'package:klee/utils/constants.dart';
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
          title: Text(
            'Oops!',
            style: TextStyle(fontSize: 24, color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    message,
                  style: TextStyle(fontFamily: 'KleeOne', fontSize: 18, color: Colors.black),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
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
