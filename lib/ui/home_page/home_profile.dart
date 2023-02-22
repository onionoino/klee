import 'package:flutter/material.dart';

import '../../service/home_page_service.dart';
import '../../utils/base_widget.dart';
import '../login_page/login_page.dart';
import 'home_image.dart';

/// the view layer of profile widget in home page
class HomeProfile extends StatefulWidget {
  final Map<dynamic, dynamic>? authData;

  const HomeProfile(this.authData, {Key? key}) : super(key: key);

  @override
  State<HomeProfile> createState() => _HomeProfileState();
}

class _HomeProfileState extends State<HomeProfile> {
  final HomePageService homePageService = HomePageService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            BaseWidget.getPadding(25.0),
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: const Text(
                  "Welcome to your POD",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: "KleeOne",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            BaseWidget.getPadding(20.0),
            const HomeImage(),
            BaseWidget.getPadding(25.0),
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
            BaseWidget.getPadding(150.0),
          ],
        ),
      ),
    );
  }
}
