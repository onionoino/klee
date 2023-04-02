import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klee/service/home_page_service.dart';
import 'package:klee/utils/base_widget.dart';
import 'package:klee/utils/constants.dart';

import '../../utils/global.dart';
import 'home_page.dart';

class HomeIndex extends StatefulWidget {
  final Map<dynamic, dynamic>? authData;

  const HomeIndex(this.authData, {Key? key}) : super(key: key);

  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  TextEditingController encKeyController = TextEditingController();
  HomePageService homePageService = HomePageService();

  @override
  Widget build(BuildContext context) {
    if (Global.isEncKeySet) {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            BaseWidget.getPadding(10),
            const Text(
              "INSTRUCTIONS",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontFamily: "KleeOne",
                fontWeight: FontWeight.bold,
              ),
            ),
            BaseWidget.getPadding(10),
            BaseWidget.getHorizontalLine(MediaQuery.of(context).size.width),
            BaseWidget.getPadding(5),
            BaseWidget.getSubTitleText(Constants.subTitle1),
            BaseWidget.getInstructionText(Constants.indexPageInstructionText1, MediaQuery.of(context).size.width - 30, 30),
            BaseWidget.getPadding(5),
            BaseWidget.getHorizontalLine(MediaQuery.of(context).size.width),
            BaseWidget.getPadding(5),
            BaseWidget.getSubTitleText(Constants.subTitle2),
            BaseWidget.getInstructionText(Constants.indexPageInstructionText2, MediaQuery.of(context).size.width - 30, 30),
            BaseWidget.getPadding(5),
            BaseWidget.getHorizontalLine(MediaQuery.of(context).size.width),
            BaseWidget.getPadding(5),
            BaseWidget.getSubTitleText(Constants.subTitle3),
            BaseWidget.getInstructionText(Constants.indexPageInstructionText3, MediaQuery.of(context).size.width - 30, 30),
            BaseWidget.getPadding(5),
            BaseWidget.getHorizontalLine(MediaQuery.of(context).size.width),
            BaseWidget.getPadding(5),
            BaseWidget.getSubTitleText(Constants.subTitle4),
            BaseWidget.getInstructionText(Constants.indexPageInstructionText4, MediaQuery.of(context).size.width - 30, 30),
            BaseWidget.getPadding(5),
            BaseWidget.getHorizontalLine(MediaQuery.of(context).size.width),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (event) async {
                if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                  if (await homePageService.checkAndSetEncKey(widget.authData, encKeyController.text)) {
                    Global.isEncKeySet = true;
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
                        return BaseWidget.getNoticeDialog(
                            context,
                            "Warning",
                            "You didn't enter your enc-key or the key is not correct",
                            "Try again");
                      },
                    );
                    return;
                  }
                }
              },
              child: TextField(
                controller: encKeyController,
                style: const TextStyle(fontSize: 18, fontFamily: "KleeOne"),
                textAlign: TextAlign.center,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText:
                  "Your Enc-Key",
                ),
                onSubmitted: (value) async {
                  if (await homePageService.checkAndSetEncKey(widget.authData, encKeyController.text)) {
                    Global.isEncKeySet = true;
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
                        return BaseWidget.getNoticeDialog(
                            context,
                            "Warning",
                            "You didn't enter your enc-key or the key is not correct",
                            "Try again");
                      },
                    );
                    return;
                  }
                },
              ),
            ),
            BaseWidget.getPadding(12.5),
            BaseWidget.getElevatedButton(() async {
              if (await homePageService.checkAndSetEncKey(widget.authData, encKeyController.text)) {
                Global.isEncKeySet = true;
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
                    return BaseWidget.getNoticeDialog(
                        context,
                        "Warning",
                        "You didn't enter your enc-key or the key is not correct",
                        "Try again");
                  },
                );
                return;
              }
            }, "Start Now", MediaQuery.of(context).size.width / 1.25, 50),
            BaseWidget.getPadding(10),
            const Text(
              "INSTRUCTIONS",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontFamily: "KleeOne",
                fontWeight: FontWeight.bold,
              ),
            ),
            BaseWidget.getPadding(10),
            BaseWidget.getHorizontalLine(MediaQuery.of(context).size.width),
            BaseWidget.getPadding(5),
            BaseWidget.getSubTitleText(Constants.subTitle1),
            BaseWidget.getInstructionText(Constants.indexPageInstructionText1, MediaQuery.of(context).size.width - 30, 30),
            BaseWidget.getPadding(5),
            BaseWidget.getHorizontalLine(MediaQuery.of(context).size.width),
            BaseWidget.getPadding(5),
            BaseWidget.getSubTitleText(Constants.subTitle2),
            BaseWidget.getInstructionText(Constants.indexPageInstructionText2, MediaQuery.of(context).size.width - 30, 30),
            BaseWidget.getPadding(5),
            BaseWidget.getHorizontalLine(MediaQuery.of(context).size.width),
            BaseWidget.getPadding(5),
            BaseWidget.getSubTitleText(Constants.subTitle3),
            BaseWidget.getInstructionText(Constants.indexPageInstructionText3, MediaQuery.of(context).size.width - 30, 30),
            BaseWidget.getPadding(5),
            BaseWidget.getHorizontalLine(MediaQuery.of(context).size.width),
            BaseWidget.getPadding(5),
            BaseWidget.getSubTitleText(Constants.subTitle4),
            BaseWidget.getInstructionText(Constants.indexPageInstructionText4, MediaQuery.of(context).size.width - 30, 30),
            BaseWidget.getPadding(5),
            BaseWidget.getHorizontalLine(MediaQuery.of(context).size.width),
            BaseWidget.getPadding(150),
          ],
        ),
      );
    }
  }
}