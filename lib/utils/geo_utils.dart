import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:klee/model/geo_info.dart';
import 'package:klee/utils/encrpt_utils.dart';
import 'package:klee/utils/time_utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:solid_encrypt/solid_encrypt.dart';

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

  /// this method convert a position object into a formatted string
  /// @param position - position object
  /// @return str - formatted string
  static String positionToString(Position position) {
    return "${position.longitude}|${position.latitude}|${TimeUtils.getFormattedTimeYYYYmmDD(DateTime.now())}|${TimeUtils.getFormattedTimeHHmmSS(DateTime.now())}";
  }

  /// this method convert a formatted geo string into a geoInfo object
  /// @param posStr - formatted string
  /// @return geoInfo - geoInfo object
  static GeoInfo bgStringToGeoInfo(String posStr) {
    GeoInfo geoInfo = GeoInfo();
    geoInfo.longitude = double.parse(posStr.split("|")[0]);
    geoInfo.latitude = double.parse(posStr.split("|")[1]);
    geoInfo.date = posStr.split("|")[2];
    geoInfo.time = posStr.split("|")[3];
    return geoInfo;
  }

  /// get a map of formatted position information for further processing
  /// @param latLng - geographical information collected from the device
  /// @param dateTime - observation time
  /// @return formattedPositionMap - the formatted K-V position map for further processing
  static Future<Map<String, String>> getFormattedPosition(
      LatLng latLng, DateTime dateTime, EncryptClient encryptClient) async {
    String? deviceInfo = await PlatformDeviceId.getDeviceId;
    if ((deviceInfo == null || deviceInfo.trim() == "") && Platform.isLinux) {
      deviceInfo = DeviceInfoPlugin().linuxInfo.toString();
    }
    String latitudeKey =
        EncryptUtils.encode(Constants.latitudeKey, encryptClient)!;
    String longitudeKey =
        EncryptUtils.encode(Constants.longitudeKey, encryptClient)!;
    String obTimeKey = EncryptUtils.encode(Constants.obTimeKey, encryptClient)!;
    String deviceKey = EncryptUtils.encode(Constants.deviceKey, encryptClient)!;
    return <String, String>{
      latitudeKey:
          EncryptUtils.encode(_getFormattedLatitude(latLng), encryptClient)!,
      longitudeKey:
          EncryptUtils.encode(_getFormattedLongitude(latLng), encryptClient)!,
      obTimeKey: EncryptUtils.encode(
          TimeUtils.getFormattedTimeYYYYmmDDHHmmSS(dateTime), encryptClient)!,
      deviceKey: EncryptUtils.encode(deviceInfo!, encryptClient)!,
    };
  }

  /// get a map of formatted position information from geoInfo for further processing
  /// @param geoInfo - geoInfo object
  /// @return formattedPositionMap - the formatted K-V position map for further processing
  static Future<Map<String, String>> getFormattedPositionFromGeoInfo(
      GeoInfo geoInfo, EncryptClient encryptClient) async {
    String? deviceInfo = await PlatformDeviceId.getDeviceId;
    if ((deviceInfo == null || deviceInfo.trim() == "") && Platform.isLinux) {
      deviceInfo = DeviceInfoPlugin().linuxInfo.toString();
    }
    String latitudeKey =
        EncryptUtils.encode(Constants.latitudeKey, encryptClient)!;
    String longitudeKey =
        EncryptUtils.encode(Constants.longitudeKey, encryptClient)!;
    String obTimeKey = EncryptUtils.encode(Constants.obTimeKey, encryptClient)!;
    String deviceKey = EncryptUtils.encode(Constants.deviceKey, encryptClient)!;
    return <String, String>{
      latitudeKey:
          EncryptUtils.encode(geoInfo.latitude.toString(), encryptClient)!,
      longitudeKey:
          EncryptUtils.encode(geoInfo.longitude.toString(), encryptClient)!,
      obTimeKey:
          EncryptUtils.encode(geoInfo.date + geoInfo.time, encryptClient)!,
      deviceKey: EncryptUtils.encode(deviceInfo!, encryptClient)!,
    };
  }

  static String _getFormattedLatitude(LatLng latLng) {
    return latLng.latitude.toString();
  }

  static String _getFormattedLongitude(LatLng latLng) {
    return latLng.longitude.toString();
  }
}
