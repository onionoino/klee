import 'package:flutter/material.dart';
import 'package:klee/model/survey_info.dart';
import 'package:klee/utils/base_widget.dart';

import '../../service/home_page_service.dart';
import '../../utils/constants.dart';
import '../login_page/login_page.dart';
import 'home_charts/bar_chart_widget.dart';
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
        child: FutureBuilder<List<SurveyInfo>?>(
          future: homePageService.getSurveyInfoList(
              Constants.barNumber, widget.authData),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // request is complete
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // request failed
                return BaseWidget.getQuestionText("Error: ${snapshot.error}");
              } else {
                // request success
                List<double> isCoughList = [];
                List<double> isSoreThroatList = [];
                List<double> temperatureList = [];
                List<double> diastolicList = [];
                List<double> heartRateList = [];
                List<double> systolicList = [];
                List<String> obTimeList = [];
                List<SurveyInfo>? surveyInfoList = snapshot.data;
                if (surveyInfoList == null) {
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
                for (SurveyInfo surveyInfo in surveyInfoList) {
                  isCoughList.add(surveyInfo.isCough);
                  isSoreThroatList.add(surveyInfo.isSoreThroat);
                  temperatureList.add(surveyInfo.temperature);
                  diastolicList.add(surveyInfo.diastolic);
                  heartRateList.add(surveyInfo.heartRate);
                  systolicList.add(surveyInfo.systolic);
                  obTimeList.add(surveyInfo.obTime);
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
                          isCoughList, obTimeList, Constants.optionMaxY),
                    ),
                    BaseWidget.getPadding(15),
                    BaseWidget.getQuestionText("Is Sore Throat"),
                    BaseWidget.getPadding(5),
                    SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: BarChartWidget(
                          isSoreThroatList, obTimeList, Constants.optionMaxY),
                    ),
                    BaseWidget.getPadding(15),
                    BaseWidget.getQuestionText("Temperature"),
                    BaseWidget.getPadding(5),
                    SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: LineChartWidget(temperatureList, obTimeList,
                          Constants.temperatureMinY),
                    ),
                    BaseWidget.getPadding(15),
                    BaseWidget.getQuestionText("Diastolic"),
                    BaseWidget.getPadding(5),
                    SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: LineChartWidget(
                          diastolicList, obTimeList, Constants.diastolicMinY),
                    ),
                    BaseWidget.getPadding(15),
                    BaseWidget.getQuestionText("Heart Rate"),
                    BaseWidget.getPadding(5),
                    SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: LineChartWidget(
                          heartRateList, obTimeList, Constants.heartRateMinY),
                    ),
                    BaseWidget.getPadding(15),
                    BaseWidget.getQuestionText("Systolic"),
                    BaseWidget.getPadding(5),
                    SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: LineChartWidget(
                          systolicList, obTimeList, Constants.systolicMinY),
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
