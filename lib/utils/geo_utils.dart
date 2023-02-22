import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

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

  static String _getFormattedLatitude(LatLng latLng) {
    return latLng.latitude.toString();
  }

  static String _getFormattedLongitude(LatLng latLng) {
    return latLng.longitude.toString();
  }

  static String _getFormattedDateTime(DateTime dateTime) {
    return dateTime.toString().substring(0, 19);
  }

  /// get a map of formatted position information for further processing
  /// @param latLng - geographical information collected from the device
  ///        dateTime - the timestamp collected along with geographical information collection
  /// @return formattedPositionMap - the formatted K-V position map for further processing
  static Map<String, String> getFormattedPosition(
      LatLng latLng, DateTime dateTime) {
    return <String, String>{
      Constants.latitude: _getFormattedLatitude(latLng),
      Constants.longitude: _getFormattedLongitude(latLng),
      Constants.dateTime: _getFormattedDateTime(dateTime),
    };
  }
}
