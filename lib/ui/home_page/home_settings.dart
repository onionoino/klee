import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';

import '../../service/home_page_service.dart';
import '../../utils/base_widget.dart';
import '../login_page/login_page.dart';

final storage = FlutterSecureStorage();  // <- initialize storage

class HomeSettings extends StatefulWidget {
  final Map<dynamic, dynamic>? authData;

  HomeSettings(this.authData);

  @override
  _HomeSettingsState createState() => _HomeSettingsState();
}

class _HomeSettingsState extends State<HomeSettings> {
  TextEditingController encKeyController = TextEditingController();
  final HomePageService homePageService = HomePageService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        Center(
          child: Text(
            'Your Information',
            style: TextStyle(
              fontSize: 30,
              fontFamily: "KleeOne",
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
        ),
        SizedBox(height: 20),
        FutureBuilder<String?>(
          future: storage.read(key: 'encKey'), // <- read from storage
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Container(
                width: double.infinity, // Take all available width
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
                    children: [
                      Text(
                        'Encryption Key:',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "KleeOne",
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: 200, // Set the width to 200
                        child: TextField(
                          controller: encKeyController..text = snapshot.data ?? 'N/A',
                          readOnly: true, // Make the TextField read-only
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "KleeOne",
                              color: Colors.blueGrey[700]),
                          textAlign: TextAlign.left,
                          autofocus: false,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(100),
                          ],
                          decoration: InputDecoration(
                            // hintText: "eg. Encryption Key",
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Colors.teal, width: 1.5),
                            ),
                          ),
                          onChanged: (text) {
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
        BaseWidget.getPadding(25),
        BaseWidget.getElevatedButton(() async {
          bool? isLogout = await showDialog<bool>(
              context: context,
              builder: (context) {
                return BaseWidget.getConfirmationDialog(
                    context,
                    "Message",
                    "Are you sure to logout?",
                    "Emm, not yet",
                    "Goodbye");
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
      ],
    );
  }
}
