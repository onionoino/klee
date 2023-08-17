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
  TextEditingController q6AnswerTextController = TextEditingController(text: "60");
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
            // BaseWidget.getQuestionText(Constants.q1Text),
            Padding(
              padding: const EdgeInsets.only(left: 15.0), // Add some left padding for distance from the border
              child: Align(
                alignment: Alignment.centerLeft,
                child: BaseWidget.getQuestionText(Constants.q1Text),
              ),
            ),
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
            // BaseWidget.getQuestionText(Constants.q6Text),
            Padding(
              padding: const EdgeInsets.only(left: 15.0), // Add some left padding for distance from the border
              child: Align(
                alignment: Alignment.centerLeft,
                child: BaseWidget.getQuestionText(Constants.q6Text),
              ),
            ),
            BaseWidget.getPadding(8.0),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Container(
                    height: 35.0,
                    width: 60.0,
                    child: ElevatedButton(
                      onPressed: () {
                        int currentValue = int.tryParse(q6AnswerTextController.text) ?? 60;
                        q6AnswerTextController.text = (currentValue - 10).toString();
                        setState(() {
                          q6Answer = q6AnswerTextController.text;
                        });
                      },
                      child: Text("-10", style: TextStyle(color: Colors.teal[700])),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blueGrey[100]),
                        foregroundColor: MaterialStateProperty.all(Colors.teal),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 5), // space between buttons
                  Container(
                    height: 30.0,
                    width: 55.0,
                    child: ElevatedButton(
                      onPressed: () {
                        int currentValue = int.tryParse(q6AnswerTextController.text) ?? 60;
                        q6AnswerTextController.text = (currentValue - 1).toString();
                        setState(() {
                          q6Answer = q6AnswerTextController.text;
                        });
                      },
                      child: Text("-1", style: TextStyle(color: Colors.teal[600])),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blueGrey[50]),
                        foregroundColor: MaterialStateProperty.all(Colors.teal),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 120,
                    alignment: Alignment.center,
                    child: TextField(
                      controller: q6AnswerTextController,
                      style: const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
                      textAlign: TextAlign.left,
                      autofocus: false,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(5),
                      ],
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: "eg 60(kg)",
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.all(10.0),
                        errorText: errorText6,
                        border: OutlineInputBorder( // Set the border shape and look
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.teal, width: 1.5),
                        ),
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
                  SizedBox(width: 10),
                  Container(
                    height: 30.0,
                    width: 55.0,
                    child: ElevatedButton(
                      onPressed: () {
                        int currentValue = int.tryParse(q6AnswerTextController.text) ?? 60;
                        q6AnswerTextController.text = (currentValue + 1).toString();
                        setState(() {
                          q6Answer = q6AnswerTextController.text;
                        });
                      },
                      child: Text("+1", style: TextStyle(color: Colors.teal[600])),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blueGrey[50]),
                        foregroundColor: MaterialStateProperty.all(Colors.teal),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 35.0,
                    width: 60.0,
                    child: ElevatedButton(
                      onPressed: () {
                        int currentValue = int.tryParse(q6AnswerTextController.text) ?? 60;
                        q6AnswerTextController.text = (currentValue + 10).toString();
                        setState(() {
                          q6Answer = q6AnswerTextController.text;
                        });
                      },
                      child: Text("+10", style: TextStyle(color: Colors.teal[700])),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blueGrey[100]),
                        foregroundColor: MaterialStateProperty.all(Colors.teal),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),// You can adjust these values
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BaseWidget.getPadding(15.0),
            // BaseWidget.getQuestionText(Constants.q2Text),
            Padding(
              padding: const EdgeInsets.only(left: 15.0), // Add some left padding for distance from the border
              child: Align(
                alignment: Alignment.centerLeft,
                child: BaseWidget.getQuestionText(Constants.q2Text),
              ),
            ),
            BaseWidget.getPadding(8.0),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 200,
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: q2AnswerTextController,
                    style: const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
                    textAlign: TextAlign.left,
                    autofocus: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(6),
                    ],
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: "eg 99(mg/dL)",
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.all(10.0),
                      errorText: errorText2,
                      border: OutlineInputBorder( // Set the border shape and look
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.teal, width: 1.5),
                      ),
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
              ),
            ),
            BaseWidget.getPadding(15.0),
            // BaseWidget.getQuestionText(Constants.q3Text),
            Padding(
              padding: const EdgeInsets.only(left: 15.0), // Add some left padding for distance from the border
              child: Align(
                alignment: Alignment.centerLeft,
                child: BaseWidget.getQuestionText(Constants.q3Text),
              ),
            ),
            BaseWidget.getPadding(8.0),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 200,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: q3AnswerTextController,
                    style: const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
                    textAlign: TextAlign.left,
                    autofocus: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(6),
                    ],
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: "eg 140(mg/dL)",
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.all(10.0),
                      errorText: errorText3,
                      border: OutlineInputBorder( // Set the border shape and look
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.teal, width: 1.5),
                      ),
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
              ),
            ),
            BaseWidget.getPadding(15.0),
            // BaseWidget.getQuestionText(Constants.q4Text),
            Padding(
              padding: const EdgeInsets.only(left: 15.0), // Add some left padding for distance from the border
              child: Align(
                alignment: Alignment.centerLeft,
                child: BaseWidget.getQuestionText(Constants.q4Text),
              ),
            ),
            BaseWidget.getPadding(8.0),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 200,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: q4AnswerTextController,
                    style: const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
                    textAlign: TextAlign.left,
                    autofocus: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(6),
                    ],
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: "eg 105(mm Hg)",
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.all(10.0),
                      errorText: errorText4,
                      border: OutlineInputBorder( // Set the border shape and look
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.teal, width: 1.5),
                      ),
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
              ),
            ),
            BaseWidget.getPadding(15.0),
            // BaseWidget.getQuestionText(Constants.q5Text),
            Padding(
              padding: const EdgeInsets.only(left: 15.0), // Add some left padding for distance from the border
              child: Align(
                alignment: Alignment.centerLeft,
                child: BaseWidget.getQuestionText(Constants.q5Text),
              ),
            ),
            BaseWidget.getPadding(8.0),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 200,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: q5AnswerTextController,
                    style: const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
                    textAlign: TextAlign.left,
                    autofocus: false,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(6),
                    ],
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: "eg 75(mm Hg)",
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.all(10.0),
                      errorText: errorText5,
                      border: OutlineInputBorder( // Set the border shape and look
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.teal, width: 1.5),
                      ),
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
