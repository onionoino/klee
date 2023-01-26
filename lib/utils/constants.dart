import 'package:latlong2/latlong.dart';

/// this class contains some constants used in this project
class Constants {
  // Login State Constants
  static const invalidURL = 0;
  static const success = 1;
  static const podNotFound = 2;

  // WebId Url Reg Check
  static final RegExp urlRegExp =
      RegExp(r"(https?)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]");

  // Default LatLng
  static final LatLng defaultLatLng = LatLng(-35.27527648107207, 149.12062976407165);

  // Auth Data Keys
  static const String accessToken = "accessToken";
  static const String webId = "webId";
  static const String podURI = "podURI";
  static const String containerURI = "containerURI";
  static const String kleeFileURI = "kleeFileURI";
  static const String rsaInfo = "rsaInfo";
  static const String rsa = "rsa";
  static const String pubKeyJwk = "pubKeyJwk";

  // Container Info
  static const String relativeContainerURI = "klee/";
  static const String containerName = "klee";

  // Klee File Info
  // static const String relativeKleeFileURI = "klee.ttl";
  static const String relativeKleeFileURI = "klee";
  static const String ttlSuffix = ".ttl";
  static const String kleeFileName = "klee";

  // Klee File Keys
  static const String latitude = "latitude";
  static const String longitude = "longitude";
  static const String dateTime = "dateTime";
  static const String q1 = "q1";
  static const String q2 = "q2";
  static const String q3 = "q3";
  static const String lastFinishTime = "lastFinishTime";

  // Klee File Geo Key List
  static const Set<String> kleeFileGeoKeyList = <String>{latitude, longitude, dateTime};

  // Klee File Survey Key List
  static const Set<String> kleeFileSurveyKeyList = <String>{q1, q2, q3, lastFinishTime};

  // HTTP Status Constants
  static const int ok = 200;
  static const int created = 201;
  static const int reset = 205;

  // None Value
  static const String none = "none";

  // Sparql Action
  static const String insert = "insert";
  static const String delete = "delete";
  static const String update = "update";

  // Predicate Prefix
  static const String predicate = "http://xmlns.com/foaf/0.1/";

  // Login Scopes
  static const List<String> scopes = <String>[
    "openid",
    "profile",
    "offline_access",
    "webid",
    "email",
    "api"
  ];

  // Question Texts
  static const String q1Text = "Are you coughing today?";
  static const String q2Text = "Are you have a sore throat today?";
  static const String q3Text = "What's your temperature today?";

  // Geo Info Saving Interval (seconds)
  static const int interval = 20;
}
