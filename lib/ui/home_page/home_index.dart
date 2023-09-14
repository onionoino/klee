import 'package:flutter/material.dart';
import 'package:securedialog/service/home_page_service.dart';
import 'package:securedialog/utils/constants.dart';
import 'dart:ui' as ui;

class HomeIndex extends StatefulWidget {
  final Map<dynamic, dynamic>? authData;
  final Function(int) onTapCard;

  const HomeIndex(this.authData, {required this.onTapCard, Key? key}) : super(key: key);

  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  TextEditingController encKeyController = TextEditingController();
  HomePageService homePageService = HomePageService();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[50],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                "Start with SecureDialog",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = ui.Gradient.linear(
                      const Offset(0, 0),
                      const Offset(0, 50),
                      [Colors.lime, Colors.teal], // Colors
                      [0.2, 1.0], // Stops, corresponding to above colors
                    ),
              ),
            ),
            Divider(
              color: Colors.blueGrey[100],
              thickness: 1,
            ),
            const SizedBox(height: 8),
            _buildInstructionCard(Constants.subTitle1, Constants.indexPageInstructionText1, Icons.home, Constants.indexPage),
            _buildInstructionCard(Constants.subTitle2, Constants.indexPageInstructionText2, Icons.zoom_in_map, Constants.mapPage),
            _buildInstructionCard(Constants.subTitle3, Constants.indexPageInstructionText3, Icons.newspaper, Constants.surveyPage),
            _buildInstructionCard(Constants.subTitle4, Constants.indexPageInstructionText4, Icons.person_outline, Constants.podPage),
            _buildInstructionCard(Constants.subTitle5, Constants.indexPageInstructionText5, Icons.settings, Constants.settingsPage),
            const SizedBox(height: 20),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildInstructionCard(String title, String content, IconData iconData, int targetPageIdx) {
    return GestureDetector(
      onTap: () {
        widget.onTapCard(targetPageIdx);
      },
      child: Card(
        color: Colors.lime[50],
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),  // Rounded corners with radius of 15
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    iconData,  // The icon data you pass in
                    color: Colors.teal,
                  ),
                  const SizedBox(width: 10),  // some spacing between the icon and text
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: "KleeOne",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: "KleeOne",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
