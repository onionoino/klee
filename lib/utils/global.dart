import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:latlong2/latlong.dart';

class Global {
  static LatLng? globalLatLng;

  // The Encryption Key
  static String encryptKey = sha256.convert(utf8.encode('my-enc-key')).toString().substring(0, 32);
}