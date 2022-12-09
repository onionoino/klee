import 'package:flutter/material.dart';

AppBar getAppBar(String barName) {
  return AppBar(
    title: Text(barName),
    elevation: 2.5,
    centerTitle: true,
    backgroundColor: Colors.deepPurpleAccent,
  );
}

Icon getMapMarkerIconRed() {
  return const Icon(
    Icons.location_on,
    size: 50,
    color: Colors.redAccent,
  );
}