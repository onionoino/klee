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
  TextEditingController q3AnswerTextController = TextEditingController();
  String? q1Answer;
  String? q2Answer;
  String? q3Answer;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            BaseWidget.getPadding(25.0),
            BaseWidget.getQuestionText(Constants.q1Text),
            BaseWidget.getPadding(2.5),
            Row(
              children: <Widget>[
                Flexible(
                  child: RadioListTile<String>(
                    value: "No",
                    title: BaseWidget.getRadioBoxAnswerText("No"),
                    activeColor: Colors.red,
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
                    title: BaseWidget.getRadioBoxAnswerText("Mild"),
                    groupValue: q1Answer,
                    activeColor: Colors.red,
                    onChanged: (value) {
                      setState(() {
                        q1Answer = value;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile<String>(
                    value: "Yes",
                    title: BaseWidget.getRadioBoxAnswerText("Yes"),
                    groupValue: q1Answer,
                    activeColor: Colors.red,
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
            Row(
              children: <Widget>[
                Flexible(
                  child: RadioListTile<String>(
                    value: "No",
                    title: BaseWidget.getRadioBoxAnswerText("No"),
                    activeColor: Colors.red,
                    groupValue: q2Answer,
                    onChanged: (value) {
                      setState(() {
                        q2Answer = value;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile<String>(
                    value: "Mild",
                    title: BaseWidget.getRadioBoxAnswerText("Mild"),
                    groupValue: q2Answer,
                    activeColor: Colors.red,
                    onChanged: (value) {
                      setState(() {
                        q2Answer = value;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile<String>(
                    value: "Yes",
                    title: BaseWidget.getRadioBoxAnswerText("Yes"),
                    groupValue: q2Answer,
                    activeColor: Colors.red,
                    onChanged: (value) {
                      setState(() {
                        q2Answer = value;
                      });
                    },
                  ),
                ),
              ],
            ),
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: "eg 36.7",
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.all(5.0),
                  errorText: errorText,
                ),
                onChanged: (temperatureText) {
                  setState(() {
                    if (!SurveyUtils.checkBodyTemperatureText(temperatureText)) {
                      errorText = "Invalid body temperature";
                      q3Answer = null;
                    } else {
                      errorText = null;
                      q3Answer = temperatureText;
                    }
                  });
                },
              ),
            ),
            BaseWidget.getPadding(15.0),
            BaseWidget.getElevatedButton(() async {
              if (q1Answer == null || q2Answer == null || q3Answer == null) {
                await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return BaseWidget.getNoticeDialog(context, "Warning",
                          "Questions may not be completed or answers are not valid", "Continue");
                    });
              } else {
                if (await homePageService.saveSurveyInfo(
                    q1Answer!, q2Answer!, q3Answer!, widget.authData, DateTime.now())) {
                  await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return BaseWidget.getNoticeDialog(context, "Message",
                            "Thank you for reporting your condition today", "Continue");
                      });
                  if (!mounted) {
                    return null;
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(widget.authData)),
                  );
                } else {
                  await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return BaseWidget.getNoticeDialog(
                            context, "Error", "Failed to connect to your POD", "Try again");
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
