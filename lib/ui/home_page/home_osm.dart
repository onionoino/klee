import 'dart:async';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:current_location/current_location.dart';
import 'package:current_location/model/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:klee/utils/constants.dart';
import 'package:klee/utils/geo_utils.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../service/home_page_service.dart';
import '../../utils/base_widget.dart';

/// the view layer of open street map widget in home page
class HomeOSM extends StatefulWidget {
  final Map<dynamic, dynamic>? authData;

  const HomeOSM(this.authData, {Key? key}) : super(key: key);

  @override
  State<HomeOSM> createState() => _HomeOSMState();
}

class _HomeOSMState extends State<HomeOSM> {
  final MapController mapController = MapController();
  LatLng? curLatLng = Constants.defaultLatLng;
  final HomePageService homePageService = HomePageService();
  bool autoGeo = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
        Location? location = await UserLocation.getValue();
        setState(() {
          curLatLng = LatLng(location!.latitude!, location.longitude!);
        });
        mapController.move(curLatLng!, Constants.defaultZoom);
      } else {
        Position position = await GeoUtils.getCurrentLocation();
        setState(() {
          curLatLng = LatLng(position.latitude, position.longitude);
        });
        homePageService.saveGeoInfo(
            curLatLng!, widget.authData, DateTime.now());
        mapController.move(curLatLng!, Constants.defaultZoom);
      }
    });
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
                Position position = await GeoUtils.getCurrentLocation();
                setState(() {
                  curLatLng = LatLng(position.latitude, position.longitude);
                });
                homePageService.saveGeoInfo(
                    curLatLng!, widget.authData, DateTime.now());
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
            });
          },
        ),
        nonRotatedChildren: [
          AttributionWidget.defaultWidget(
            source: 'OpenStreetMap',
            onSourceTapped: null,
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 25),
            child: FloatingActionButton(
              onPressed: () {
                // TODO
                print("TOGGLE");
              },
              backgroundColor: Colors.redAccent,
              child: const Icon(
                Icons.slideshow,
                color: Colors.white,
                size: 42,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
            child: FloatingActionButton(
              onPressed: () async {
                autoGeo = true;
                Position position = await GeoUtils.getCurrentLocation();
                setState(() {
                  curLatLng = LatLng(position.latitude, position.longitude);
                  mapController.move(curLatLng!, Constants.defaultZoom);
                });
              },
              backgroundColor: Colors.redAccent,
              child: const Icon(
                Icons.gps_fixed,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 90),
            child: FloatingActionButton(
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
              backgroundColor: Colors.redAccent,
              child: const Icon(
                Icons.add_circle_outline,
                color: Colors.white,
                size: 45,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 25),
            child: FloatingActionButton(
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
              backgroundColor: Colors.redAccent,
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
}
