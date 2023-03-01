import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'constants.dart';

/// this class is a util class related to geographical affairs
class GeoUtils {
  /// this method get the current location from the device, but not working for linux
  /// @return position - the current position from the OS of the device
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  /// get a map of formatted position information for further processing
  /// @param latLng - geographical information collected from the device
  /// @return formattedPositionMap - the formatted K-V position map for further processing
  static Future<Map<String, String>> getFormattedPosition(LatLng latLng) async {
    String? deviceInfo = await PlatformDeviceId.getDeviceId;
    return <String, String>{
      Constants.latitudeKey: _getFormattedLatitude(latLng),
      Constants.longitudeKey: _getFormattedLongitude(latLng),
      Constants.deviceKey: deviceInfo!,
    };
  }

  static String _getFormattedLatitude(LatLng latLng) {
    return latLng.latitude.toString();
  }

  static String _getFormattedLongitude(LatLng latLng) {
    return latLng.longitude.toString();
  }
}
