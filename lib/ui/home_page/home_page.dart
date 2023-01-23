import 'package:flutter/material.dart';
import 'package:klee/ui/home_page/home_osm.dart';
import 'package:klee/ui/home_page/home_profile.dart';
import 'package:klee/ui/home_page/home_survey.dart';
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
  List<Widget> widgetList = <Widget>[];
  int curWidgetIdx = 1;

  @override
  void initState() {
    super.initState();
    widgetList
      ..add(HomeSurvey(widget.authData))
      ..add(HomeOSM(widget.authData))
      ..add(HomeProfile(widget.authData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseWidget.getAppBar("Klee Compass"),
      body: IndexedStack(
        index: curWidgetIdx,
        children: widgetList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: curWidgetIdx,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: "Q&A",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.zoom_in_map),
            label: "MAP",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "POD",
          )
        ],
        onTap: onTapEvent,
      ),
    );
  }

  /// tap event logic when taping bottomNavigationBar, set selected idx to current idx
  /// @param selectedIdx - selected index of the bottomNavigationBar
  /// @return void
  void onTapEvent(int selectedIdx) {
    setState(() {
      curWidgetIdx = selectedIdx;
    });
  }

  // /// tap event logic when taping bottomNavigationBar
  // /// @param curIdx - current index of the bottomNavigationBar, > 1 means logout button is tapped
  // ///                 < 1 means survey button is tapped
  // /// @return void
  // void onTapEvent(int selectIdx) async {
  //   if (selectIdx == Constants.surveyPageIdx) {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
  //       return HomeSurvey(widget.authData);
  //     }));
  //   }
  //   if (selectIdx == Constants.logoutPageIdx) {
  //     bool? isLogout = await showDialog<bool>(
  //         context: context,
  //         builder: (context) {
  //           return BaseWidget.getConfirmationDialog(
  //               context, "Message", "Are you sure to logout?", "Emm, not yet", "Goodbye");
  //         });
  //     if (isLogout == null || !isLogout || !mounted) {
  //       return;
  //     }
  //     homePageService.logout(widget.authData!["logoutUrl"]);
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
  //       return const LoginPage();
  //     }));
  //   }
  // }
}
