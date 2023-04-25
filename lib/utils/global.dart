import 'package:latlong2/latlong.dart';

class Global {
  static LatLng? globalLatLng;

  // The Encryption Key
  static late String encryptKey;

  // The Encryption Toggle
  static bool isEncKeySet = false;
}
