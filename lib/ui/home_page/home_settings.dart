import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';

import '../../service/home_page_service.dart';  // Make sure to import your home_page_service
import '../../utils/base_widget.dart';  // Make sure to import your base_widget
import '../login_page/login_page.dart';  // Make sure to import your login_page

final storage = FlutterSecureStorage();  // Initialize secure storage

class HomeSettings extends StatefulWidget {
  final Map<dynamic, dynamic>? authData;

  HomeSettings(this.authData);

  @override
  _HomeSettingsState createState() => _HomeSettingsState();
}

class _HomeSettingsState extends State<HomeSettings> {
  TextEditingController encKeyController = TextEditingController();
  final HomePageService homePageService = HomePageService();
  bool isTextVisible = false;

  @override
  void initState() {
    super.initState();
    _loadEncryptionKey();
  }

  _loadEncryptionKey() async {
    String? storedKey = await storage.read(key: 'encKey');
    setState(() {
      encKeyController.text = storedKey ?? 'N/A';
    });
  }

  _updateEncryptionKey(String newKey) async {
    await storage.write(key: 'encKey', value: newKey);  // Write to storage
    _loadEncryptionKey();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[50],
      child: Column(
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
            future: storage.read(key: 'encKey'),  // Read from storage
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 200,
                              child: TextField(
                                controller: encKeyController,
                                readOnly: false,
                                obscureText: !isTextVisible,
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
                                  hintText: "Your Enc-Key",
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
                                  suffixIcon: IconButton(  // Add this icon button
                                    icon: Icon(
                                      isTextVisible ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.teal[400],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isTextVisible = !isTextVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 18),
                            ElevatedButton(
                              onPressed: () {
                                _updateEncryptionKey(encKeyController.text);
                              },
                              child: Text(" SAVE "),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.teal[400]),
                                // Other styles here
                              ),
                            ),
                          ],
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
      ),
    );
  }
}
