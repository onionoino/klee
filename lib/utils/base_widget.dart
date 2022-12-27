import 'package:flutter/material.dart';

/// this class contains a lot of base widgets to reduce repeated codes and improve decoupling
class BaseWidget {
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
      Icons.location_on,
      size: 50,
      color: Colors.redAccent,
    );
  }

  static TextField getTextField(String hint, TextEditingController textEditingController) {
    return TextField(
      controller: textEditingController,
      style: const TextStyle(fontSize: 20, fontFamily: "KleeOne"),
      textAlign: TextAlign.center,
      autofocus: true,
      decoration: InputDecoration(
        hintText: hint,
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

  static AlertDialog getNoticeDialog(
      BuildContext context, String title, String content, String textButton) {
    return AlertDialog(
      title: const Text("A warning from Klee"),
      content: const Text("You gave an invalid webId"),
      actions: <Widget>[
        TextButton(
          child: const Text("Try again"),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
      ],
    );
  }

  static AlertDialog getConfirmationDialog(
      BuildContext context, String title, String content, String textButtonF, String textButtonT) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
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
