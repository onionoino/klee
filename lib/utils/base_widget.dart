import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// this class contains a lot of base widgets to reduce repeated codes and improve decoupling
class BaseWidget {
  static BottomNavigationBarItem getNavBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: Colors.white),
      label: label,
      backgroundColor: Color(int.parse("e74c3c", radix: 16) | 0xFF000000),
    );
  }

  static AppBar getAppBar(String barName) {
    return AppBar(
      title: Text(barName),
      titleTextStyle: const TextStyle(fontSize: 25, fontFamily: "KleeOne"),
      elevation: 2.5,
      centerTitle: true,
    );
  }

  static Icon getMapMarkerIconRed() {
    return const Icon(
      Icons.adjust,
      size: 40,
      color: Colors.redAccent,
    );
  }

  static TextField getTextField(
      String hint, TextEditingController textEditingController) {
    return TextField(
      controller: textEditingController,
      style: const TextStyle(fontSize: 20, fontFamily: "KleeOne"),
      textAlign: TextAlign.center,
      autofocus: false,
      decoration: InputDecoration(
        hintText: hint,
      ),
    );
  }

  static Text getHintText(String hintText) {
    return Text(
      hintText,
      style: const TextStyle(
        fontSize: 15,
        fontFamily: "KleeOne",
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Text getQuestionText(String questionText) {
    return Text(
      questionText,
      style: const TextStyle(
        fontSize: 20,
        fontFamily: "KleeOne",
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Text getRadioBoxAnswerText(String answerText) {
    return Text(
      answerText,
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }

  static BarTooltipItem getBarTooltipItem(String tooltipText) {
    return BarTooltipItem(
      tooltipText,
      textAlign: TextAlign.center,
      const TextStyle(
        color: Colors.limeAccent,
        fontWeight: FontWeight.bold,
        fontSize: 9,
      ),
    );
  }

  static LineTooltipItem getLineTooltipItem(String tooltipText) {
    return LineTooltipItem(
      tooltipText,
      const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 9,
      ),
    );
  }

  static ElevatedButton getElevatedButton(
      Function() tapEvent, String label, double width, double height) {
    return ElevatedButton(
      onPressed: tapEvent,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height),
        textStyle: const TextStyle(fontSize: 25, fontFamily: "KleeOne"),
      ),
      child: Text(label),
    );
  }

  static Padding getPadding(double value) {
    return Padding(padding: EdgeInsets.all(value));
  }

  static Container getHorizontalLine(double width) {
    return Container(width: width, height: 2, color: Colors.black26);
  }

  static Text getSubTitleText(String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        fontSize: 20,
        fontFamily: "KleeOne",
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Text getTitleText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 22,
        fontFamily: "KleeOne",
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Container getInstructionTextContainer(String text, double width, double padding) {
    return Container(
      alignment: Alignment.topCenter,
      width: width,
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 18,
          fontFamily: "KleeOne",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static AlertDialog getNoticeDialog(
      BuildContext context, String title, String content, String textButton) {
    return AlertDialog(
      title: Text(textAlign: TextAlign.center, title),
      content: Text(textAlign: TextAlign.center, content),
      actions: <Widget>[
        TextButton(
          child: Text(textButton),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
      ],
    );
  }

  static AlertDialog getConfirmationDialog(BuildContext context, String title,
      String content, String textButtonF, String textButtonT) {
    return AlertDialog(
      title: Text(textAlign: TextAlign.center, title),
      content: Text(textAlign: TextAlign.center, content),
      actions: <Widget>[
        TextButton(
          child: Text(textButtonF),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text(textButtonT),
          onPressed: () {
            // close and return to LoginPage
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
