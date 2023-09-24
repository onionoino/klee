/// A widget for displaying the SURVEY page.
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
import 'package:flutter/services.dart';

import 'package:securedialog/service/home_page_service.dart';
import 'package:securedialog/ui/home_page/home_page.dart';
import 'package:securedialog/utils/base_widget.dart';
import 'package:securedialog/utils/constants.dart';
import 'package:securedialog/utils/survey_utils.dart';

/// the view layer of survey widget in home page

class HomeSurvey extends StatefulWidget {
  final Map<dynamic, dynamic>? authData;

  const HomeSurvey(this.authData, {Key? key}) : super(key: key);

  @override
  State<HomeSurvey> createState() => _HomeSurveyState();
}

class _HomeSurveyState extends State<HomeSurvey> {
  final HomePageService homePageService = HomePageService();
  late FocusNode focusNode2;
  late FocusNode focusNode3;
  late FocusNode focusNode4;
  late FocusNode focusNode5;
  late FocusNode focusNode6;
  late FocusNode focusNode7;
  TextEditingController q2AnswerTextController = TextEditingController();
  TextEditingController q3AnswerTextController = TextEditingController();
  TextEditingController q4AnswerTextController = TextEditingController();
  TextEditingController q5AnswerTextController = TextEditingController();
  TextEditingController q6AnswerTextController =
      TextEditingController(text: "60");
  TextEditingController q7AnswerTextController = TextEditingController();
  String? q1Answer;
  String? q2Answer;
  String? q3Answer;
  String? q4Answer;
  String? q5Answer;
  String? q6Answer;
  String? q7Answer;
  String? errorText2;
  String? errorText3;
  String? errorText4;
  String? errorText5;
  String? errorText6;
  String? errorText7;

  @override
  void initState() {
    super.initState();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();
    focusNode4 = FocusNode();
    focusNode5 = FocusNode();
    focusNode6 = FocusNode();
    focusNode7 = FocusNode();
  }

  @override
  void dispose() {
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    focusNode5.dispose();
    focusNode6.dispose();
    focusNode7.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              BaseWidget.getPadding(15.0),
              // BaseWidget.getQuestionText(Constants.q4Text),
              Padding(
                padding: const EdgeInsets.only(
                    left:
                        15.0), // Add some left padding for distance from the border
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
                      focusNode: focusNode5,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(focusNode6),
                      controller: q4AnswerTextController,
                      style:
                          const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
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
                        border: OutlineInputBorder(
                          // Set the border shape and look
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 1.5),
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
                padding: const EdgeInsets.only(
                    left:
                        15.0), // Add some left padding for distance from the border
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
                      focusNode: focusNode6,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(focusNode7),
                      controller: q5AnswerTextController,
                      style:
                          const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
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
                        border: OutlineInputBorder(
                          // Set the border shape and look
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 1.5),
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
              // BaseWidget.getQuestionText(Constants.q7Text),
              Padding(
                padding: const EdgeInsets.only(
                    left:
                        15.0), // Add some left padding for distance from the border
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: BaseWidget.getQuestionText(Constants.q7Text),
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
                      focusNode: focusNode7,
                      onEditingComplete: () => focusNode7.unfocus(),
                      controller: q7AnswerTextController,
                      style:
                          const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
                      textAlign: TextAlign.left,
                      autofocus: false,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(6),
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: "eg 86(bpm)",
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.all(10.0),
                        errorText: errorText7,
                        border: OutlineInputBorder(
                          // Set the border shape and look
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 1.5),
                        ),
                      ),
                      onChanged: (heartRateText) {
                        setState(() {
                          if (!SurveyUtils.checkHeartRateText(heartRateText)) {
                            errorText7 = "Invalid heart rate value";
                            q7Answer = null;
                          } else {
                            errorText7 = null;
                            if (heartRateText.trim() == "") {
                              q7Answer = null;
                            } else {
                              q7Answer = heartRateText;
                            }
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),

              BaseWidget.getPadding(15.0),
              // BaseWidget.getQuestionText(Constants.q6Text),
              Padding(
                padding: const EdgeInsets.only(
                    left:
                        15.0), // Add some left padding for distance from the border
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: BaseWidget.getQuestionText(Constants.q6Text),
                ),
              ),
              BaseWidget.getPadding(8.0),
              ////////////////////////////////////////////////////////////////////////
              // WEIGHT
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 35.0,
                      width: 60.0,
                      child: ElevatedButton(
                        onPressed: () {
                          int currentValue =
                              int.tryParse(q6AnswerTextController.text) ?? 60;
                          q6AnswerTextController.text =
                              (currentValue - 10).toString();
                          setState(() {
                            q6Answer = q6AnswerTextController.text;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blueGrey[100]),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.teal),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        child: Text("-10",
                            style: TextStyle(color: Colors.teal[700])),
                      ),
                    ),

                    const SizedBox(width: 5), // space between buttons
                    SizedBox(
                      height: 30.0,
                      width: 55.0,
                      child: ElevatedButton(
                        onPressed: () {
                          int currentValue =
                              int.tryParse(q6AnswerTextController.text) ?? 60;
                          q6AnswerTextController.text =
                              (currentValue - 1).toString();
                          setState(() {
                            q6Answer = q6AnswerTextController.text;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blueGrey[50]),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.teal),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        child: Text("-1",
                            style: TextStyle(color: Colors.teal[600])),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 120,
                      alignment: Alignment.center,
                      child: TextField(
                        focusNode: focusNode2,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(focusNode3),
                        controller: q6AnswerTextController,
                        style: const TextStyle(
                            fontSize: 18, fontFamily: "KleeOne"),
                        textAlign: TextAlign.left,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(5),
                        ],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          hintText: "eg 60(kg)",
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.all(10.0),
                          errorText: errorText6,
                          border: OutlineInputBorder(
                            // Set the border shape and look
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.teal, width: 1.5),
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
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 30.0,
                      width: 55.0,
                      child: ElevatedButton(
                        onPressed: () {
                          int currentValue =
                              int.tryParse(q6AnswerTextController.text) ?? 60;
                          q6AnswerTextController.text =
                              (currentValue + 1).toString();
                          setState(() {
                            q6Answer = q6AnswerTextController.text;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blueGrey[50]),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.teal),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        child: Text("+1",
                            style: TextStyle(color: Colors.teal[600])),
                      ),
                    ),
                    const SizedBox(width: 5),
                    SizedBox(
                      height: 35.0,
                      width: 60.0,
                      child: ElevatedButton(
                        onPressed: () {
                          int currentValue =
                              int.tryParse(q6AnswerTextController.text) ?? 60;
                          q6AnswerTextController.text =
                              (currentValue + 10).toString();
                          setState(() {
                            q6Answer = q6AnswerTextController.text;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blueGrey[100]),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.teal),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ), // You can adjust these values
                        ),
                        child: Text("+10",
                            style: TextStyle(color: Colors.teal[700])),
                      ),
                    ),
                  ],
                ),
              ),
              ////////////////////////////////////////////////////////////////////////
              // SUBMIT
              BaseWidget.getPadding(15.0),
              BaseWidget.getElevatedButton(() async {
                if (q1Answer == null &&
                    q2Answer == null &&
                    q3Answer == null &&
                    q4Answer == null &&
                    q5Answer == null &&
                    q6Answer == null &&
                    q7Answer == null) {
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
                  q7Answer ??= Constants.none;
                  if (await homePageService.saveSurveyInfo(
                      q1Answer!,
                      q2Answer!,
                      q3Answer!,
                      q4Answer!,
                      q5Answer!,
                      q6Answer!,
                      q7Answer!,
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
              BaseWidget.getPadding(15.0),
              // BaseWidget.getQuestionText(Constants.q1Text),
              Padding(
                padding: const EdgeInsets.only(
                    left:
                        15.0), // Add some left padding for distance from the border
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
              // BaseWidget.getQuestionText(Constants.q2Text),
              Padding(
                padding: const EdgeInsets.only(
                    left:
                        15.0), // Add some left padding for distance from the border
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
                      focusNode: focusNode3,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(focusNode4),
                      controller: q2AnswerTextController,
                      style:
                          const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
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
                        border: OutlineInputBorder(
                          // Set the border shape and look
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 1.5),
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
                padding: const EdgeInsets.only(
                    left:
                        15.0), // Add some left padding for distance from the border
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
                      focusNode: focusNode4,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(focusNode5),
                      controller: q3AnswerTextController,
                      style:
                          const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
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
                        border: OutlineInputBorder(
                          // Set the border shape and look
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 1.5),
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
              BaseWidget.getPadding(150.0),
            ],
          ),
        ),
      ),
    );
  }
}
