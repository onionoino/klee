import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:klee/net/file_action.dart';
import 'package:klee/utils/geo_utils.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../service/home_page_service.dart';
import '../../utils/ui_base_components.dart';

class OSM extends StatefulWidget {
  const OSM({Key? key}) : super(key: key);

  @override
  State<OSM> createState() => _OSMState();
}

class _OSMState extends State<OSM> {
  final MapController mapController = MapController();
  LatLng? curLatLng;
  final FileAction fileAction = FileAction();
  final HomePageService homePageService = HomePageService();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCurrentLocation().then((loc) {
        final curLatLng = LatLng(loc.latitude, loc.longitude);
        setState(() {
          this.curLatLng = curLatLng;
        });
        mapController.move(curLatLng, 17);
      });
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
            minZoom: 12.0,
            maxZoom: 18.0,
            keepAlive: true,
            onMapReady: () {
              LogUtil.e("map init complete");
              timer = Timer.periodic(const Duration(seconds: 10), (timer) {
                LogUtil.e(
                    "refresh the map and write location info into local file");
                getCurrentLocation().then((loc) {
                  final curLatLng = LatLng(loc.latitude, loc.longitude);
                  setState(() {
                    this.curLatLng = curLatLng;
                  });
                  // record current time
                  homePageService.saveLocation(curLatLng);
                  // verify the result
                  homePageService.showAllRecords();
                });
              });
            }),
        nonRotatedChildren: [
          AttributionWidget.defaultWidget(
            source: 'OpenStreetMap',
            onSourceTapped: null,
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
                      return getMapMarkerIconRed();
                    }))
            ],
          )
        ],
      ),
    );
  }
}
