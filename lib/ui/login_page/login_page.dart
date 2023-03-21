import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klee/utils/base_widget.dart';
import 'package:klee/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service/login_page_service.dart';
import '../home_page/home_page.dart';
import 'login_image.dart';

/// the view layer of login page
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TODO for testing
  // TextEditingController webIdController = TextEditingController()
  //   ..text = 'https://podtest123.solidcommunity.net/profile/card#me';

  // TextEditingController webIdController = TextEditingController()
  //   ..text = 'https://solid.ecosysl.net/podtest123/profile/card#me';

  TextEditingController webIdController = TextEditingController();
  final LoginPageService loginPageService = LoginPageService();

  _load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastInputURL = prefs.getString(Constants.lastInputURLKey);
    if (lastInputURL != null && lastInputURL != Constants.none) {
      webIdController = TextEditingController()..text = lastInputURL;
    }
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
      appBar: BaseWidget.getAppBar("Klee Compass"),
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
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage(authData, Constants.indexPage)),
                  );
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
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage(authData, Constants.indexPage)),
                  );
                },
              ),
            ),
            BaseWidget.getPadding(20.0),
            BaseWidget.getElevatedButton(() async {
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
                return null;
              }
              Map<dynamic, dynamic>? authData = await loginPageService
                  .loginAndAuth(webIdController.text, context, mounted);
              if (!mounted) {
                return null;
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(authData, Constants.indexPage)),
              );
            }, "Login", MediaQuery.of(context).size.width / 1.25, 50),
            BaseWidget.getPadding(150.0),
          ],
        ),
      ),
      backgroundColor: Color(int.parse("fadbd8", radix: 16) | 0xFF000000),
    );
  }
}
