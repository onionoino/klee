import 'package:flutter/cupertino.dart';

class HomeIndex extends StatefulWidget {
  final Map<dynamic, dynamic>? authData;

  const HomeIndex(this.authData, {Key? key}) : super(key: key);

  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: const Text(
        """HOME PAGE""",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontFamily: "KleeOne",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
