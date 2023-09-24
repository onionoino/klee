/// The widget for displaying HOME page
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
/// Authors: Bowen Yang, Ye Duan, Graham Williams

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:securedialog/service/home_page_service.dart';
import 'package:securedialog/ui/home_page/home_index.dart';
import 'package:securedialog/ui/home_page/home_osm.dart';
import 'package:securedialog/ui/home_page/home_profile.dart';
import 'package:securedialog/ui/home_page/home_settings.dart';
import 'package:securedialog/ui/home_page/home_survey.dart';
import 'package:securedialog/utils/base_widget.dart';
import 'package:securedialog/utils/constants.dart';
import 'package:securedialog/utils/global.dart';
import 'package:securedialog/utils/notify_utils.dart';
import 'package:securedialog/utils/time_utils.dart';

/// the view layer of home page, a stateful widget
class HomePage extends StatefulWidget {
  final Map<dynamic, dynamic>? authData;
  final int defaultPage;

  const HomePage(this.authData, this.defaultPage, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageService homePageService = HomePageService();
  List<Widget> widgetList = <Widget>[];
  int curWidgetIdx = Constants.indexPage;

  @override
  void initState() {
    curWidgetIdx = widget.defaultPage;
    super.initState();
    widgetList
      ..add(HomeIndex(widget.authData, onTapCard: (int idx) {
        setState(() {
          curWidgetIdx = idx;
        });
      }))
      ..add(HomeSurvey(widget.authData))
      ..add(HomeProfile(widget.authData))
      ..add(HomeProfile(widget.authData))
      ..add(HomeOSM(widget.authData))
      ..add(HomeSettings(widget.authData));
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: receiveMethod,
    );
    NotifyUtils.scheduleNotifications();
  }

  Future<void> receiveMethod(ReceivedAction receivedAction) async {
    String? lastSurveyTime =
        await homePageService.getLastSurveyTime(widget.authData!);
    if (lastSurveyTime == Constants.none) {
      setState(() {
        curWidgetIdx = Constants.surveyPage;
      });
      return;
    }
    String lastSurveyDate = lastSurveyTime.substring(0, 8);
    String? currentDate = TimeUtils.getFormattedTimeYYYYmmDD(DateTime.now());
    if (lastSurveyDate == currentDate) {
      String lastSurveyHH = lastSurveyTime.substring(8, 10);
      String lastSurveyMM = lastSurveyTime.substring(10, 12);
      String lastSurveySS = lastSurveyTime.substring(12);
      String lastSurveyHHmmSS = "$lastSurveyHH:$lastSurveyMM:$lastSurveySS";
      bool? isGoBack = await showDialog<bool>(
          context: context,
          builder: (context) {
            return BaseWidget.getConfirmationDialog(
                context,
                "Message",
                "Thank you for reporting condition today.\nWould you like to submit a new report?\nLast Report was submitted on $lastSurveyHHmmSS today!",
                "New report",
                "Come back tmr");
          });
      if (isGoBack == null || isGoBack || !mounted) {
        setState(() {
          curWidgetIdx = Constants.mapPage;
        });
      } else {
        setState(() {
          curWidgetIdx = Constants.surveyPage;
        });
      }
    } else {
      setState(() {
        curWidgetIdx = Constants.surveyPage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseWidget.getAppBar("SecureDiaLog"),
      body: IndexedStack(
        index: curWidgetIdx,
        children: widgetList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: curWidgetIdx,
        items: [
          BaseWidget.getNavBarItem(Icons.home, "HOME"),
          BaseWidget.getNavBarItem(Icons.note_alt_outlined, "SURVEY"),
          BaseWidget.getNavBarItem(Icons.bar_chart_rounded, "CHARTS"),
          BaseWidget.getNavBarItem(Icons.table_view_rounded, "DATA"),
          BaseWidget.getNavBarItem(Icons.map_outlined, "MAP"),
          BaseWidget.getNavBarItem(Icons.settings, "SETTINGS"),
        ],
        onTap: _onTapEvent,
      ),
    );
  }

  /// tap event logic when taping bottomNavigationBar, set selected idx to current idx
  /// @param selectedIdx - selected index of the bottomNavigationBar
  /// @return void
  Future<void> _onTapEvent(int selectedIdx) async {
    if (Global.isEncKeySet) {
      if (selectedIdx == Constants.surveyPage) {
        String? lastSurveyTime =
            await homePageService.getLastSurveyTime(widget.authData!);
        if (lastSurveyTime == Constants.none) {
          setState(() {
            curWidgetIdx = Constants.surveyPage;
          });
          return;
        }
        String lastSurveyDate = lastSurveyTime.substring(0, 8);
        String? currentDate =
            TimeUtils.getFormattedTimeYYYYmmDD(DateTime.now());
        if (lastSurveyDate == currentDate) {
          String lastSurveyHH = lastSurveyTime.substring(8, 10);
          String lastSurveyMM = lastSurveyTime.substring(10, 12);
          String lastSurveySS = lastSurveyTime.substring(12);
          String lastSurveyHHmmSS = "$lastSurveyHH:$lastSurveyMM:$lastSurveySS";
          bool? isGoBack = await showDialog<bool>(
              context: context,
              builder: (context) {
                return BaseWidget.getConfirmationDialog(
                    context,
                    "Message",
                    "Thank you for reporting condition today.\nWould you like to submit a new report?\nLast Report is submitted on $lastSurveyHHmmSS today!",
                    "New report",
                    "Come back tmr");
              });
          if (isGoBack == null || isGoBack || !mounted) {
            return;
          }
        }
      }
      setState(() {
        curWidgetIdx = selectedIdx;
      });
    } else {
      if (selectedIdx != Constants.indexPage) {
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return BaseWidget.getNoticeDialog(
                context,
                "Warning",
                "Pls enter or set your enc-key to verify your identity before using the feature",
                "Enter now");
          },
        );
      }
    }
  }
}
