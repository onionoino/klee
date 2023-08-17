import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../service/home_page_service.dart';
import '../../utils/base_widget.dart';
import '../../utils/constants.dart';
import '../../utils/survey_utils.dart';
import 'home_page.dart';

/// the view layer of survey widget in home page
class HomeSurvey extends StatefulWidget {
  final Map<dynamic, dynamic>? authData;

  const HomeSurvey(this.authData, {Key? key}) : super(key: key);

  @override
  State<HomeSurvey> createState() => _HomeSurveyState();
}

class _HomeSurveyState extends State<HomeSurvey> {
  final HomePageService homePageService = HomePageService();
  TextEditingController q2AnswerTextController = TextEditingController();
  TextEditingController q3AnswerTextController = TextEditingController();
  TextEditingController q4AnswerTextController = TextEditingController();
  TextEditingController q5AnswerTextController = TextEditingController();
  TextEditingController q6AnswerTextController = TextEditingController();
  String? q1Answer;
  String? q2Answer;
  String? q3Answer;
  String? q4Answer;
  String? q5Answer;
  String? q6Answer;
  String? errorText2;
  String? errorText3;
  String? errorText4;
  String? errorText5;
  String? errorText6;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            BaseWidget.getPadding(15.0),
            BaseWidget.getQuestionText(Constants.q1Text),
            BaseWidget.getPadding(2.5),
            BaseWidget.getHintText(Constants.radioListHintText),
            Row(
              children: <Widget>[
                Flexible(
                  child: RadioListTile<String>(
                    value: "No",
                    title: BaseWidget.getRadioBoxAnswerText("0"),
                    activeColor: Colors.teal,
                    groupValue: q1Answer,
                    onChanged: (value) {
                      setState(() {
                        q1Answer = value;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile<String>(
                    value: "Mild",
                    title: BaseWidget.getRadioBoxAnswerText("1"),
                    groupValue: q1Answer,
                    activeColor: Colors.teal,
                    onChanged: (value) {
                      setState(() {
                        q1Answer = value;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile<String>(
                    value: "Moderate",
                    title: BaseWidget.getRadioBoxAnswerText("2"),
                    groupValue: q1Answer,
                    activeColor: Colors.teal,
                    onChanged: (value) {
                      setState(() {
                        q1Answer = value;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile<String>(
                    value: "Severe",
                    title: BaseWidget.getRadioBoxAnswerText("3"),
                    groupValue: q1Answer,
                    activeColor: Colors.teal,
                    onChanged: (value) {
                      setState(() {
                        q1Answer = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            BaseWidget.getPadding(15.0),
            BaseWidget.getQuestionText(Constants.q2Text),
            BaseWidget.getPadding(2.5),
            Container(
              width: 200,
              alignment: Alignment.center,
              child: TextField(
                controller: q2AnswerTextController,
                style: const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
                textAlign: TextAlign.center,
                autofocus: false,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(4),
                ],
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: "eg 99(mg/dL)",
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.all(5.0),
                  errorText: errorText2,
                ),
                onChanged: (fastingText) {
                  setState(() {
                    if (!SurveyUtils.checkFastingBloodGlucoseText(
                        fastingText)) {
                      errorText2 = "Invalid value";
                      q2Answer = null;
                    } else {
                      if (fastingText.trim() == "") {
                        q2Answer = null;
                      } else {
                        if (fastingText.contains(".")) {
                          q2Answer = fastingText;
                        } else {
                          q2Answer = "$fastingText.0";
                        }
                      }
                      errorText2 = null;
                    }
                  });
                },
              ),
            ),
            // BaseWidget.getPadding(15.0),
            // BaseWidget.getQuestionText(Constants.q2Text),
            // BaseWidget.getPadding(2.5),
            // BaseWidget.getHintText(Constants.radioListHintText),
            // Row(
            //   children: <Widget>[
            //     Flexible(
            //       child: RadioListTile<String>(
            //         value: "No",
            //         title: BaseWidget.getRadioBoxAnswerText("0"),
            //         activeColor: Colors.teal,
            //         groupValue: q2Answer,
            //         onChanged: (value) {
            //           setState(() {
            //             q2Answer = value;
            //           });
            //         },
            //       ),
            //     ),
            //     Flexible(
            //       child: RadioListTile<String>(
            //         value: "Mild",
            //         title: BaseWidget.getRadioBoxAnswerText("1"),
            //         groupValue: q2Answer,
            //         activeColor: Colors.teal,
            //         onChanged: (value) {
            //           setState(() {
            //             q2Answer = value;
            //           });
            //         },
            //       ),
            //     ),
            //     Flexible(
            //       child: RadioListTile<String>(
            //         value: "Moderate",
            //         title: BaseWidget.getRadioBoxAnswerText("2"),
            //         groupValue: q2Answer,
            //         activeColor: Colors.teal,
            //         onChanged: (value) {
            //           setState(() {
            //             q2Answer = value;
            //           });
            //         },
            //       ),
            //     ),
            //     Flexible(
            //       child: RadioListTile<String>(
            //         value: "Severe",
            //         title: BaseWidget.getRadioBoxAnswerText("3"),
            //         groupValue: q2Answer,
            //         activeColor: Colors.teal,
            //         onChanged: (value) {
            //           setState(() {
            //             q2Answer = value;
            //           });
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            BaseWidget.getPadding(15.0),
            BaseWidget.getQuestionText(Constants.q3Text),
            BaseWidget.getPadding(2.5),
            Container(
              width: 200,
              alignment: Alignment.center,
              child: TextField(
                controller: q3AnswerTextController,
                style: const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
                textAlign: TextAlign.center,
                autofocus: false,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(4),
                ],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: "eg 140(mg/dL)",
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.all(5.0),
                  errorText: errorText3,
                ),
                onChanged: (postprandialText) {
                  setState(() {
                    if (!SurveyUtils.checkPostprandialBloodGlucoseText(
                        postprandialText)) {
                      errorText3 = "Invalid value";
                      q3Answer = null;
                    } else {
                      if (postprandialText.trim() == "") {
                        q3Answer = null;
                      } else {
                        if (postprandialText.contains(".")) {
                          q3Answer = postprandialText;
                        } else {
                          q3Answer = "$postprandialText.0";
                        }
                      }
                      errorText3 = null;
                    }
                  });
                },
              ),
            ),
            BaseWidget.getPadding(15.0),
            BaseWidget.getQuestionText(Constants.q4Text),
            BaseWidget.getPadding(2.5),
            Container(
              width: 200,
              alignment: Alignment.center,
              child: TextField(
                controller: q4AnswerTextController,
                style: const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
                textAlign: TextAlign.center,
                autofocus: false,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(3),
                ],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: "eg 105",
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.all(5.0),
                  errorText: errorText4,
                ),
                onChanged: (systolicText) {
                  setState(() {
                    if (!SurveyUtils.checkSystolicText(systolicText)) {
                      errorText4 = "Invalid systolic value";
                      q4Answer = null;
                    } else {
                      errorText4 = null;
                      if (systolicText.trim() == "") {
                        q4Answer = null;
                      } else {
                        q4Answer = systolicText;
                      }
                    }
                  });
                },
              ),
            ),
            BaseWidget.getPadding(15.0),
            BaseWidget.getQuestionText(Constants.q5Text),
            BaseWidget.getPadding(2.5),
            Container(
              width: 200,
              alignment: Alignment.center,
              child: TextField(
                controller: q5AnswerTextController,
                style: const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
                textAlign: TextAlign.center,
                autofocus: false,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(3),
                ],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: "eg 75",
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.all(5.0),
                  errorText: errorText5,
                ),
                onChanged: (diastolicText) {
                  setState(() {
                    if (!SurveyUtils.checkDiastolicText(diastolicText)) {
                      errorText5 = "Invalid diastolic value";
                      q5Answer = null;
                    } else {
                      errorText5 = null;
                      if (diastolicText.trim() == "") {
                        q5Answer = null;
                      } else {
                        q5Answer = diastolicText;
                      }
                    }
                  });
                },
              ),
            ),
            BaseWidget.getPadding(15.0),
            BaseWidget.getQuestionText(Constants.q6Text),
            BaseWidget.getPadding(2.5),
            Container(
              width: 200,
              alignment: Alignment.center,
              child: TextField(
                controller: q6AnswerTextController,
                style: const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
                textAlign: TextAlign.center,
                autofocus: false,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(3),
                ],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: "eg 85",
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.all(5.0),
                  errorText: errorText6,
                ),
                onChanged: (weightText) {
                  setState(() {
                    if (!SurveyUtils.checkWeightText(weightText)) {
                      errorText6 = "Invalid weight";
                      q6Answer = null;
                    } else {
                      errorText6 = null;
                      if (weightText.trim() == "") {
                        q6Answer = null;
                      } else {
                        q6Answer = weightText;
                      }
                    }
                  });
                },
              ),
            ),
            BaseWidget.getPadding(15.0),
            BaseWidget.getElevatedButton(() async {
              if (q1Answer == null &&
                  q2Answer == null &&
                  q3Answer == null &&
                  q4Answer == null &&
                  q5Answer == null &&
                  q6Answer == null) {
                await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return BaseWidget.getNoticeDialog(
                          context,
                          "Warning",
                          "An empty report can not be submitted, pls answer at least one question",
                          "Continue");
                    });
              } else {
                q1Answer ??= Constants.none;
                q2Answer ??= Constants.none;
                q3Answer ??= Constants.none;
                q4Answer ??= Constants.none;
                q5Answer ??= Constants.none;
                q6Answer ??= Constants.none;
                if (await homePageService.saveSurveyInfo(
                    q1Answer!,
                    q2Answer!,
                    q3Answer!,
                    q4Answer!,
                    q5Answer!,
                    q6Answer!,
                    widget.authData,
                    DateTime.now())) {
                  await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return BaseWidget.getNoticeDialog(
                            context,
                            "Message",
                            "Thank you for reporting your condition today",
                            "Continue");
                      });
                  if (!mounted) {
                    return null;
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage(widget.authData, Constants.mapPage)),
                  );
                } else {
                  await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return BaseWidget.getNoticeDialog(context, "Error",
                            "Failed to connect to your POD", "Try again");
                      });
                }
              }
            }, "Submit", MediaQuery.of(context).size.width / 1.25, 50),
            BaseWidget.getPadding(150.0),
          ],
        ),
      ),
    );
  }
}
