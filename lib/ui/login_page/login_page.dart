import 'package:flutter/material.dart';
import 'package:klee/utils/base_widget.dart';

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
  // for testing
  TextEditingController webIdController = TextEditingController()
    ..text = 'https://podtest123.solidcommunity.net/profile/card#me';
  final LoginPageService loginPageService = LoginPageService();

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
            BaseWidget.getTextField(
                "https://pod-url.example-server.net/profile/card#me", webIdController),
            BaseWidget.getPadding(15.0),
            BaseWidget.getElevatedButton(() async {
              if (!loginPageService.loginPreCheck(webIdController.text)) {
                await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return BaseWidget.getNoticeDialog(
                          context, "Warning", "You gave an invalid webId", "Try again");
                    });
                return;
              }
              if (!mounted) {
                return null;
              }
              Map<dynamic, dynamic>? authData =
                  await loginPageService.loginAndAuth(webIdController.text, context, mounted);
              if (!mounted) {
                return null;
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage(authData)),
              );
            }, "Login", MediaQuery.of(context).size.width / 1.25, 50),
            BaseWidget.getPadding(100.0),
          ],
        ),
      ),
      backgroundColor: Color(int.parse("fadbd8", radix: 16) | 0xFF000000),
    );
  }
}
