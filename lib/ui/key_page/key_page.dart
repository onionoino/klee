import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:klee/service/home_page_service.dart';
import 'package:klee/service/key_page_service.dart';

import '../../utils/base_widget.dart';
import '../../utils/constants.dart';
import '../../utils/global.dart';
import '../home_page/home_page.dart';
import '../login_page/login_page.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class KeyPage extends StatefulWidget {
  final Map<dynamic, dynamic>? authData;

  const KeyPage(this.authData, {Key? key}) : super(key: key);

  @override
  State<KeyPage> createState() => _KeyPageState();
}

class _KeyPageState extends State<KeyPage> {
  final storage = FlutterSecureStorage();
  TextEditingController encKeyController = TextEditingController();
  final KeyPageService keyPageService = KeyPageService();
  final HomePageService homePageService = HomePageService();
  bool isIconVisible = false;
  bool hidePassword = true;

  // // Inside your recoverKey function
  // Future<void> recoverKey() async {
  //   final smtpServer = gmail('your.email@gmail.com', 'your.password');
  //
  //   final message = Message()
  //     ..from = Address('your.email@gmail.com', 'Your Name')
  //     ..recipients.add('user@example.com') // User's email
  //     ..subject = 'Key Recovery'
  //     ..text = 'Your recovery key: <Insert Recovery Key Here>';
  //
  //   try {
  //     final sendReport = await send(message, smtpServer);
  //     print('Message sent: ${sendReport.toString()}');
  //   } catch (e) {
  //     print('Error sending email: $e');
  //   }
  //
  //   // Placeholder logic: Show a message to the user
  //   showDialog<bool>(
  //     context: context,
  //     builder: (context) {
  //       return BaseWidget.getNoticeDialog(
  //         context,
  //         "Recover Key",
  //         "An email has been sent to recover your key.",
  //         "OK",
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseWidget.getAppBar("SecureDiaLog"),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            BaseWidget.getPadding(15.0),
            Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width - 30,
              child: BaseWidget.getTitleText(
                  """For your privacy, please enter your encryption key first, if you haven't had a key yet, SecureDiaLog will help you create a new key for later identity verification."""),
            ),
            BaseWidget.getPadding(2.5),
            RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (event) async {
                if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                  if (await keyPageService.checkAndSetEncKey(
                      widget.authData, encKeyController.text)) {
                    await storage.write(key: 'encKey', value: encKeyController.text);
                    Global.isEncKeySet = true;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePage(widget.authData, Constants.indexPage)),
                    );
                  } else {
                    await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return BaseWidget.getNoticeDialog(
                            context,
                            "Warning",
                            "You didn't enter your enc-key or the key is not correct",
                            "Try again");
                      },
                    );
                    return;
                  }
                }
              },
              child: TextField(
                controller: encKeyController,
                onChanged: (value) {
                  //try this
                  value.isNotEmpty ? setState(() => isIconVisible = true) : setState(() => isIconVisible = false);
                  //or
                  setState(() => value.isNotEmpty ? isIconVisible = true : isIconVisible = false);
                  //the result is the same it's just a shortcode
                },
                obscureText: hidePassword,
                style: const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
                textAlign: TextAlign.center,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Your Enc-Key",
                  suffixIcon:  isIconVisible ? IconButton(
                    onPressed: (){
                      setState(() => hidePassword = !hidePassword);
                    },
                    icon:  Icon(
                      hidePassword ?
                      Icons.visibility_off : Icons.visibility,
                    ),
                  ) : null,
                ),
                onSubmitted: (value) async {
                  if (await keyPageService.checkAndSetEncKey(
                      widget.authData, encKeyController.text)) {
                    Global.isEncKeySet = true;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePage(widget.authData, Constants.indexPage)),
                    );
                  } else {
                    await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return BaseWidget.getNoticeDialog(
                            context,
                            "Warning",
                            "You didn't enter your enc-key or the key is not correct",
                            "Try again");
                      },
                    );
                    return;
                  }
                },
              ),
            ),
            BaseWidget.getPadding(15),
            BaseWidget.getElevatedButton(() async {
              if (await keyPageService.checkAndSetEncKey(
                  widget.authData, encKeyController.text)) {
                await storage.write(key: 'encKey', value: encKeyController.text);
                Global.isEncKeySet = true;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage(widget.authData, Constants.indexPage)),
                );
              } else {
                await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return BaseWidget.getNoticeDialog(
                        context,
                        "Warning",
                        "You didn't enter your enc-key or the key is not correct",
                        "Try again");
                  },
                );
                return;
              }
            }, "Start Now", MediaQuery.of(context).size.width / 1.25, 50),
            BaseWidget.getPadding(15),
            BaseWidget.getElevatedButton(() async {
              bool? isLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return BaseWidget.getConfirmationDialog(context, "Message",
                        "Are you sure to logout?", "Emm, not yet", "Goodbye");
                  });
              if (isLogout == null || !isLogout || !mounted) {
                return;
              }
              homePageService.logout(widget.authData!["logoutUrl"]);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) {
                return const LoginPage();
              }));
            }, "Logout", MediaQuery.of(context).size.width / 1.25, 50),

            // // Button to trigger key recovery
            // BaseWidget.getPadding(15),
            // BaseWidget.getElevatedButton(() async {
            //   await recoverKey();
            // }, "Recover Key", MediaQuery.of(context).size.width / 1.25, 50),

            BaseWidget.getPadding(150),
          ],
        ),
      ),
      backgroundColor: Colors.orange[50],
    );
  }
}
