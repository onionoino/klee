import 'package:flutter/material.dart';
import 'package:klee/ui/home_page/home_osm.dart';
import 'package:klee/ui/login_page/login_page.dart';
import 'package:klee/utils/base_widget.dart';

import '../../service/home_page_service.dart';

/// the view layer of home page, a stateful widget
class HomePage extends StatefulWidget {
  final Map<dynamic, dynamic>? authData;

  const HomePage(this.authData, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageService homePageService = HomePageService();

  int curIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseWidget.getAppBar("Compass"),
      body: HomeOSM(widget.authData),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: curIdx,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.zoom_in_map),
            label: "X&Y",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: "Logout",
          )
        ],
        onTap: logout,
      ),
    );
  }

  /// logout logic when taping Logout button
  /// @param curIdx - current index of the bottomNavigationBar, > 0 means logout button is tapped
  /// @return void
  void logout(int curIdx) async {
    if (curIdx != 0) {
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return const LoginPage();
      }));
    }
  }
}
