import 'dart:async';

import 'package:common_utils/common_utils.dart';
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
  LatLng? curLatLng;
  final HomePageService homePageService = HomePageService();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        Position position = await GeoUtils.getCurrentLocation();
        setState(() {
          curLatLng = LatLng(position.latitude, position.longitude);
        });
      } catch (e) {
        setState(() {
          curLatLng = Constants.defaultLatLng;
        });
      }
      homePageService.saveGeoInfo(curLatLng!, widget.authData, DateTime.now());
      mapController.move(curLatLng!, 17);
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
            minZoom: 8.0,
            maxZoom: 18.0,
            keepAlive: true,
            onMapReady: () {
              LogUtil.e("map init complete");
              timer = Timer.periodic(const Duration(seconds: Constants.interval), (timer) async {
                LogUtil.e("refresh the map and write position info into local file");
                Position position = await GeoUtils.getCurrentLocation();
                setState(() {
                  curLatLng = LatLng(position.latitude, position.longitude);
                });
                homePageService.saveGeoInfo(curLatLng!, widget.authData, DateTime.now());
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
                      return BaseWidget.getMapMarkerIconRed();
                    }))
            ],
          ),
        ],
      ),
    );
  }
}
