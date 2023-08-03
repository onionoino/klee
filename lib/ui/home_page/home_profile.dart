import 'package:flutter/material.dart';
import 'package:klee/model/chart_point.dart';
import 'package:klee/model/survey_day_info.dart';
import 'package:klee/utils/base_widget.dart';
import 'package:klee/utils/chart_utils.dart';
import 'package:klee/utils/time_utils.dart';

import '../../model/tooltip.dart';
import '../../service/home_page_service.dart';
import '../../utils/constants.dart';
import '../login_page/login_page.dart';
import 'home_charts/bar_chart_widget.dart';
import 'home_charts/group_chart_widget.dart';
import 'home_charts/line_chart_widget.dart';

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
        child: FutureBuilder<List<SurveyDayInfo>?>(
          future: homePageService.getSurveyDayInfoList(
              Constants.barNumber, widget.authData),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // request is complete
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // request failed
                return Column(
                  children: <Widget>[
                    BaseWidget.getPadding(15.0),
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
                    BaseWidget.getPadding(25),
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text(
                        "Server Error:${snapshot.error}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "KleeOne",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
              } else {
                // request success
                List<double> isCoughList = [];
                List<String> isCoughTimeList = [];
                List<double> isSoreThroatList = [];
                List<String> isSoreThroatTimeList = [];
                List<double> temperatureList = [];
                List<String> temperatureTimeList = [];
                List<double> diastolicList = [];
                List<String> diastolicTimeList = [];
                List<double> heartRateList = [];
                List<String> heartRateTimeList = [];
                List<double> systolicList = [];
                List<String> systolicTimeList = [];
                List<String> obTimeList = [];
                List<List<ToolTip>> isCoughToolTipsList = [];
                List<List<ToolTip>> isSoreThroatToolTipsList = [];
                List<List<ToolTip>> temperatureToolTipsList = [];
                List<List<ToolTip>> diastolicToolTipsList = [];
                List<List<ToolTip>> heartRateToolTipsList = [];
                List<List<ToolTip>> systolicToolTipsList = [];
                List<SurveyDayInfo>? surveyDayInfoList = snapshot.data;
                if (surveyDayInfoList == null) {
                  return Column(
                    children: <Widget>[
                      BaseWidget.getPadding(15.0),
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
                      BaseWidget.getPadding(25),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: const Text(
                          """Ops, something wrong when fetching your reports' data (::>_<::)\nThe data analysis function will only start working after reporting at least one Q&A survey""",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "KleeOne",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                      }, "Logout", MediaQuery.of(context).size.width / 1.25,
                          50),
                    ],
                  );
                }
                List<ChartPoint> chartPointList = ChartUtils.parseToChart(
                    surveyDayInfoList, Constants.barNumber);
                for (ChartPoint charPoint in chartPointList) {
                  isCoughList.add(charPoint.isCoughMax);
                  isCoughTimeList.add(charPoint.isCoughMaxTime);
                  isSoreThroatList.add(charPoint.isSoreThroatMax);
                  isSoreThroatTimeList.add(charPoint.isSoreThroatMaxTime);
                  temperatureList.add(charPoint.temperatureMax);
                  temperatureTimeList.add(charPoint.temperatureMaxTime);
                  diastolicList.add(charPoint.diastolicMax);
                  diastolicTimeList.add(charPoint.diastolicMaxTime);
                  heartRateList.add(charPoint.heartRateMax);
                  heartRateTimeList.add(charPoint.heartRateMaxTime);
                  systolicList.add(charPoint.systolicMax);
                  systolicTimeList.add(charPoint.systolicMaxTime);
                  obTimeList
                      .add(TimeUtils.convertDateToWeekDay(charPoint.obTimeDay));
                  isCoughToolTipsList.add(charPoint.otherIsCough);
                  isSoreThroatToolTipsList.add(charPoint.otherIsSoreThroat);
                  temperatureToolTipsList.add(charPoint.otherTemperature);
                  diastolicToolTipsList.add(charPoint.otherDiastolic);
                  heartRateToolTipsList.add(charPoint.otherHeartRate);
                  systolicToolTipsList.add(charPoint.otherSystolic);
                }
                return Column(
                  children: <Widget>[
                    BaseWidget.getPadding(15.0),
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
                    BaseWidget.getPadding(15),
                    BaseWidget.getQuestionText("Is Cough"),
                    SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: BarChartWidget(
                          isCoughList,
                          isCoughTimeList,
                          obTimeList,
                          Constants.optionMaxY,
                          isCoughToolTipsList),
                    ),
                    BaseWidget.getPadding(15),
                    BaseWidget.getQuestionText("Is Sore Throat"),
                    BaseWidget.getPadding(5),
                    SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: BarChartWidget(
                          isSoreThroatList,
                          isSoreThroatTimeList,
                          obTimeList,
                          Constants.optionMaxY,
                          isSoreThroatToolTipsList),
                    ),
                    BaseWidget.getPadding(15),
                    BaseWidget.getQuestionText("Temperature"),
                    BaseWidget.getPadding(5),
                    SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: LineChartWidget(
                          temperatureList,
                          temperatureTimeList,
                          obTimeList,
                          Constants.temperatureMinY,
                          temperatureToolTipsList),
                    ),
                    BaseWidget.getPadding(15),
                    BaseWidget.getQuestionText("Systolic"),
                    BaseWidget.getPadding(5),
                    SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: GroupChartWidget(
                          systolicList,
                          systolicTimeList,
                          obTimeList,
                          Constants.systolicMinY,
                          systolicToolTipsList),
                    ),
                    BaseWidget.getPadding(15),
                    BaseWidget.getQuestionText("Diastolic"),
                    BaseWidget.getPadding(5),
                    SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: LineChartWidget(
                          diastolicList,
                          diastolicTimeList,
                          obTimeList,
                          Constants.diastolicMinY,
                          diastolicToolTipsList),
                    ),
                    BaseWidget.getPadding(15),
                    BaseWidget.getQuestionText("Heart Rate"),
                    BaseWidget.getPadding(5),
                    SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: LineChartWidget(
                          heartRateList,
                          heartRateTimeList,
                          obTimeList,
                          Constants.heartRateMinY,
                          heartRateToolTipsList),
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
                    BaseWidget.getPadding(150.0),
                  ],
                );
              }
            } else {
              // requesting，display 'loading'
              return Container(
                height: MediaQuery.of(context).size.height - 150,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
