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
import 'home_charts/syncfusion_column_chart_widget.dart';
import 'home_charts/syncfusion_line_chart_widget.dart';

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
    return Container(
      color: Colors.orange[50],
      child: SafeArea(
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
                  List<double> strengthList = [];
                  List<String> strengthTimeList = [];
                  List<double> fastingList = [];
                  List<String> fastingTimeList = [];
                  List<double> postprandialList = [];
                  List<String> postprandialTimeList = [];
                  List<double> diastolicList = [];
                  List<String> diastolicTimeList = [];
                  List<double> weightList = [];
                  List<String> weightTimeList = [];
                  List<double> systolicList = [];
                  List<String> systolicTimeList = [];
                  List<double> heartRateList = [];
                  List<String> heartRateTimeList = [];
                  List<String> obTimeList = [];
                  List<String> timeList = [];
                  List<List<ToolTip>> strengthToolTipsList = [];
                  List<List<ToolTip>> fastingToolTipsList = [];
                  List<List<ToolTip>> postprandialToolTipsList = [];
                  List<List<ToolTip>> diastolicToolTipsList = [];
                  List<List<ToolTip>> weightToolTipsList = [];
                  List<List<ToolTip>> systolicToolTipsList = [];
                  List<List<ToolTip>> heartRateToolTipsList = [];
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
                    strengthList.add(charPoint.strengthMax);
                    strengthTimeList.add(charPoint.strengthMaxTime);
                    fastingList.add(charPoint.fastingMax);
                    fastingTimeList.add(charPoint.fastingMaxTime);
                    postprandialList.add(charPoint.postprandialMax);
                    postprandialTimeList.add(charPoint.postprandialMaxTime);
                    diastolicList.add(charPoint.diastolicMax);
                    diastolicTimeList.add(charPoint.diastolicMaxTime);
                    weightList.add(charPoint.weightMax);
                    weightTimeList.add(charPoint.weightMaxTime);
                    systolicList.add(charPoint.systolicMax);
                    systolicTimeList.add(charPoint.systolicMaxTime);
                    heartRateList.add(charPoint.heartRateMax);
                    heartRateTimeList.add(charPoint.heartRateMaxTime);
                    obTimeList
                        .add(TimeUtils.convertDateToWeekDay(charPoint.obTimeDay));
                    timeList.add(TimeUtils.reformatDate(charPoint.obTimeDay));
                    strengthToolTipsList.add(charPoint.otherStrength);
                    fastingToolTipsList.add(charPoint.otherFasting);
                    postprandialToolTipsList.add(charPoint.otherPostprandial);
                    diastolicToolTipsList.add(charPoint.otherDiastolic);
                    weightToolTipsList.add(charPoint.otherWeight);
                    systolicToolTipsList.add(charPoint.otherSystolic);
                    heartRateToolTipsList.add(charPoint.otherHeartRate);
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
                      BaseWidget.getQuestionText("Lacking in Strength Check"),
                      SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: SyncfusionColumnChartWidget(
                            strengthList,
                            strengthTimeList,
                            timeList,
                            Constants.optionMaxY,
                            strengthToolTipsList),
                      ),
                      BaseWidget.getPadding(15),
                      BaseWidget.getQuestionText("Fasting Blood Glucose"),
                      BaseWidget.getPadding(5),
                      SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: SyncfusionLineChartWidget(
                            fastingList,
                            fastingTimeList,
                            timeList,
                            Constants.fastingMinY,
                            fastingToolTipsList),
                      ),
                      BaseWidget.getPadding(15),
                      BaseWidget.getQuestionText("Postprandial Blood Glucose"),
                      BaseWidget.getPadding(5),
                      SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: SyncfusionLineChartWidget(
                            postprandialList,
                            postprandialTimeList,
                            timeList,
                            Constants.postprandialMinY,
                            postprandialToolTipsList),
                      ),
                      BaseWidget.getPadding(15),
                      BaseWidget.getQuestionText("Systolic & Diastolic"),
                      BaseWidget.getPadding(5),
                      SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: GroupChartWidget(
                            systolicList,
                            diastolicList,
                            systolicTimeList,
                            timeList,
                            Constants.systolicMinY,
                            systolicToolTipsList,
                            diastolicToolTipsList),
                      ),
                      BaseWidget.getPadding(15),
                      BaseWidget.getQuestionText("Weight"),
                      BaseWidget.getPadding(5),
                      SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: SyncfusionLineChartWidget(
                            weightList,
                            weightTimeList,
                            timeList,
                            Constants.weightMinY,
                            weightToolTipsList),
                      ),
                      BaseWidget.getPadding(15),
                      BaseWidget.getQuestionText("Heart Rate"),
                      BaseWidget.getPadding(5),
                      SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: SyncfusionLineChartWidget(
                            heartRateList,
                            heartRateTimeList,
                            timeList,
                            Constants.heartRateMinY,
                            heartRateToolTipsList),
                      ),

                      BaseWidget.getPadding(30.0),
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
      ),
    );
  }
}
