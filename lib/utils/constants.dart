import 'package:latlong2/latlong.dart';

/// this class contains some constants used in this project
class Constants {
  // Login State Constants
  static const invalidURL = 0;
  static const success = 1;
  static const podNotFound = 2;

  // HTTP Status Constants
  static const int ok = 200;
  static const int created = 201;
  static const int reset = 205;

  // WebId Url Reg Check
  static final RegExp urlRegExp =
      RegExp(r"(https?)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]");

  // Default LatLng
  static final LatLng defaultLatLng =
      LatLng(-35.27527648107207, 149.12062976407165);

  // Auth Data Keys
  static const String accessToken = "accessToken";
  static const String webId = "webId";
  static const String podURI = "podURI";
  static const String containerURI = "containerURI";
  static const String geoContainerURI = "geoContainerURI";
  static const String surveyContainerURI = "surveyContainerURI";
  static const String rsaInfo = "rsaInfo";
  static const String rsa = "rsa";
  static const String pubKeyJwk = "pubKeyJwk";

  // Container Info
  static const String relativeContainerURI = "klee/";
  static const String containerName = "klee";

  // Geo Container Info
  static const String relativeGeoContainerURI = "geo/";
  static const String geoContainerName = "geo";

  // Survey Container Info
  static const String relativeSurveyContainerURI = "survey/";
  static const String surveyContainerName = "survey";

  // TTL File Info
  static const String ttlSuffix = ".ttl";

  // Geo File Keys
  static const String latitudeKey = "latitude";
  static const String longitudeKey = "longitude";

  // Survey File Keys
  static const String q1Key = "isCough";
  static const String q2Key = "isSoreThroat";
  static const String q3Key = "temperature";
  static const String q4Key = "systolic";
  static const String q5Key = "diastolic";
  static const String q6Key = "heartRate";

  // Common Keys
  static const String deviceKey = "device";

  // None Value
  static const String none = "none";

  // Sparql Action
  static const String insert = "insert";
  static const String delete = "delete";

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
  static const String q4Text = "What's your systolic today?";
  static const String q5Text = "What's your diastolic today?";
  static const String q6Text = "What's your heart rate today?";

  // Geo Info Saving Interval (seconds)
  static const int interval = 60;

  // The Notify Hour Every Day (hour)
  static const int notificationHour = 9;

  // Shared Preference Keys
  static const String lastScheduledDateKey = "lastScheduledDate";
  static const String lastInputURLKey = "lastInputURL";

  // Redis Configs
  static const String redisIp = "54.95.123.162";
  static const int redisPort = 6379;
}
