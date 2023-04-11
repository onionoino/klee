import 'package:flutter/material.dart';
import 'package:klee/service/home_page_service.dart';
import 'package:klee/utils/base_widget.dart';
import 'package:klee/utils/constants.dart';

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
          BaseWidget.getInstructionText(
              Constants.indexPageInstructionText1, MediaQuery.of(context).size.width - 30, 30),
          BaseWidget.getPadding(5),
          BaseWidget.getHorizontalLine(MediaQuery.of(context).size.width),
          BaseWidget.getPadding(5),
          BaseWidget.getSubTitleText(Constants.subTitle2),
          BaseWidget.getInstructionText(
              Constants.indexPageInstructionText2, MediaQuery.of(context).size.width - 30, 30),
          BaseWidget.getPadding(5),
          BaseWidget.getHorizontalLine(MediaQuery.of(context).size.width),
          BaseWidget.getPadding(5),
          BaseWidget.getSubTitleText(Constants.subTitle3),
          BaseWidget.getInstructionText(
              Constants.indexPageInstructionText3, MediaQuery.of(context).size.width - 30, 30),
          BaseWidget.getPadding(5),
          BaseWidget.getHorizontalLine(MediaQuery.of(context).size.width),
          BaseWidget.getPadding(5),
          BaseWidget.getSubTitleText(Constants.subTitle4),
          BaseWidget.getInstructionText(
              Constants.indexPageInstructionText4, MediaQuery.of(context).size.width - 30, 30),
          BaseWidget.getPadding(5),
          BaseWidget.getHorizontalLine(MediaQuery.of(context).size.width),
          BaseWidget.getPadding(25),
        ],
      ),
    );
  }
}
