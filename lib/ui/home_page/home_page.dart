import 'package:flutter/material.dart';
import 'package:klee/ui/home_page/osm.dart';
import 'package:klee/utils/ui_base_components.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Klee's Location"),
      body: const OSM(),
    );
  }
}
