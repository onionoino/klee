/// The widget for displaying GEO page
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
/// Authors: Bowen Yang, Ye Duan

import 'dart:async';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:current_location/current_location.dart';
import 'package:current_location/model/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:workmanager/workmanager.dart';

import 'package:securedialog/model/geo_info.dart';
import 'package:securedialog/service/home_page_service.dart';
import 'package:securedialog/utils/base_widget.dart';
import 'package:securedialog/utils/constants.dart';
import 'package:securedialog/utils/device_file_utils.dart';
import 'package:securedialog/utils/geo_utils.dart';
import 'package:securedialog/utils/global.dart';

/// Dispatch background tasks.
/// @return void
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == Constants.simplePeriodicTask) {
      LogUtil.e("Background task starts");
      Position position = await GeoUtils.getCurrentLocation();
      String str = GeoUtils.positionToString(position);
      await DeviceFileUtils.writeContent("$str\n");
    }
    return Future.value(true);
  });
}

/// Create the view layer of an open street map widget in the home page.

class HomeOSM extends StatefulWidget {
  final Map<dynamic, dynamic>? authData;

  const HomeOSM(this.authData, {Key? key}) : super(key: key);

  @override
  State<HomeOSM> createState() => _HomeOSMState();
}

class _HomeOSMState extends State<HomeOSM> with WidgetsBindingObserver {
  final MapController mapController = MapController();
  LatLng? curLatLng = Constants.defaultLatLng;
  final HomePageService homePageService = HomePageService();
  bool autoGeo = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (Global.globalLatLng != null) {
        setState(() {
          curLatLng = Global.globalLatLng;
          mapController.move(curLatLng!, Constants.defaultZoom);
        });
      } else {
        if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
          Location? location = await UserLocation.getValue();
          setState(() {
            curLatLng = LatLng(location!.latitude!, location.longitude!);
            Global.globalLatLng = curLatLng;
          });
          mapController.move(curLatLng!, Constants.defaultZoom);
        } else {
          Position position = await GeoUtils.getCurrentLocation();
          setState(() {
            curLatLng = LatLng(position.latitude, position.longitude);
            Global.globalLatLng = curLatLng;
          });
          homePageService.saveGeoInfo(
              curLatLng!, widget.authData, DateTime.now());
          mapController.move(curLatLng!, Constants.defaultZoom);
        }
      }
    });
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: curLatLng,
          minZoom: Constants.minZoom,
          maxZoom: Constants.maxZoom,
          keepAlive: true,
          onMapReady: () {
            LogUtil.e("map init complete");
            timer = Timer.periodic(const Duration(seconds: Constants.interval),
                (timer) async {
              LogUtil.e("refresh the map and write position info into pod");
              if (autoGeo) {
                if (Platform.isLinux ||
                    Platform.isWindows ||
                    Platform.isMacOS) {
                  Location? location = await UserLocation.getValue();
                  setState(() {
                    curLatLng =
                        LatLng(location!.latitude!, location.longitude!);
                    Global.globalLatLng = curLatLng;
                  });
                  homePageService.saveGeoInfo(
                      curLatLng!, widget.authData, DateTime.now());
                } else {
                  Position position = await GeoUtils.getCurrentLocation();
                  setState(() {
                    curLatLng = LatLng(position.latitude, position.longitude);
                    Global.globalLatLng = curLatLng;
                  });
                  homePageService.saveGeoInfo(
                      curLatLng!, widget.authData, DateTime.now());
                }
              } else {
                homePageService.saveGeoInfo(
                    curLatLng!, widget.authData, DateTime.now());
              }
            });
          },
          onTap: (tapPosition, latLng) {
            autoGeo = false;
            setState(() {
              curLatLng = latLng;
              Global.globalLatLng = curLatLng;
            });
          },
        ),
        nonRotatedChildren: [
          // 20230630 gjw The following results in
          //
          // ERROR: lib/ui/home_page/home_osm.dart:147:11: Error: The getter 'AttributionWidget' isn't defined for the class '_HomeOSMState'.
          // ERROR:  - '_HomeOSMState' is from 'package:klee/ui/home_page/home_osm.dart' ('lib/ui/home_page/home_osm.dart').
          // ERROR: Try correcting the name to the name of an existing getter, or defining a getter or field named 'AttributionWidget'.
          // ERROR:           AttributionWidget.defaultWidget(
          // ERROR:           ^^^^^^^^^^^^^^^^^
          // ERROR: Target kernel_snapshot failed: Exception
          //
          // What is the purpose of this code? Seems to work when commented out.
          //
          // AttributionWidget.defaultWidget(
          //   source: 'OpenStreetMap',
          //   onSourceTapped: null,
          // ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () async {
                autoGeo = true;
                if (Platform.isLinux ||
                    Platform.isWindows ||
                    Platform.isMacOS) {
                  Location? location = await UserLocation.getValue();
                  setState(() {
                    curLatLng =
                        LatLng(location!.latitude!, location.longitude!);
                    Global.globalLatLng = curLatLng;
                    mapController.move(curLatLng!, Constants.defaultZoom);
                  });
                } else {
                  Position position = await GeoUtils.getCurrentLocation();
                  setState(() {
                    curLatLng = LatLng(position.latitude, position.longitude);
                    Global.globalLatLng = curLatLng;
                    mapController.move(curLatLng!, Constants.defaultZoom);
                  });
                }
              },
              backgroundColor: Colors.teal,
              child: const Icon(
                Icons.gps_fixed,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 25),
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                if (mapController.zoom + Constants.stepZoom <
                    Constants.maxZoom) {
                  setState(() {
                    mapController.move(
                        curLatLng!, mapController.zoom + Constants.stepZoom);
                  });
                } else {
                  setState(() {
                    mapController.move(curLatLng!, Constants.maxZoom);
                  });
                }
              },
              backgroundColor: Colors.teal,
              child: const Icon(
                Icons.add_circle_outline,
                color: Colors.white,
                size: 45,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 25),
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                if (mapController.zoom - Constants.stepZoom >
                    Constants.minZoom) {
                  setState(() {
                    mapController.move(
                        curLatLng!, mapController.zoom - Constants.stepZoom);
                  });
                } else {
                  setState(() {
                    mapController.move(curLatLng!, Constants.minZoom);
                  });
                }
              },
              backgroundColor: Colors.teal,
              child: const Icon(
                Icons.remove_circle_outline,
                color: Colors.white,
                size: 45,
              ),
            ),
          ),
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'onionoino.klee',
          ),
          MarkerLayer(
            markers: [
              if (curLatLng != null)
                Marker(
                    point: curLatLng!,
                    builder: ((context) {
                      return BaseWidget.getMapMarkerIconRed();
                    }))
            ],
          ),
        ],
      ),
    );
  }

  /// detect current app status
  /// @param state - current app status
  /// @return void
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    LogUtil.e("App lifecycle state monitor: $state");
    switch (state) {
      case AppLifecycleState.resumed:
        Workmanager().cancelAll().then((value) async {
          String content = await DeviceFileUtils.readContent();
          List<String> lines = content.split("\n");
          for (String geoStr in lines) {
            if (geoStr.trim() == "") {
              continue;
            }
            GeoInfo geoInfo = GeoUtils.bgStringToGeoInfo(geoStr);
            await homePageService.saveBgGeoInfo(widget.authData, geoInfo);
          }
          await DeviceFileUtils.clear();
          LogUtil.e("All bg-tasks have been canceled");
          LogUtil.e("Local geographical info has been refreshed into POD");
        });
        break;
      case AppLifecycleState.paused:
        Workmanager().registerPeriodicTask(
          Constants.simplePeriodicTask,
          Constants.simplePeriodicTask,
          frequency: const Duration(minutes: 15),
        );
        break;
      default:
        break;
    }
  }
}
