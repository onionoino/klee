import 'package:latlong2/latlong.dart';

/// this class contains some constants used in this project
class Constants {
  // Page Indices
  static const int indexPage = 0;
  static const int mapPage = 1;
  static const int surveyPage = 2;
  static const int podPage = 3;

  // Login State Constants
  static const int invalidURL = 0;
  static const int success = 1;
  static const int podNotFound = 2;

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

  // Enc Container Info
  static const String encRelativeContainerURI = "encryption/";
  static const String encContainerName = "encryption";

  // Container Info
  static const String relativeContainerURI = "secureDiaLog/";
  static const String containerName = "secureDiaLog";

  // Geo Container Info
  static const String relativeGeoContainerURI = "geo/";
  static const String geoContainerName = "geo";

  // Survey Container Info
  static const String relativeSurveyContainerURI = "survey/";
  static const String surveyContainerName = "survey";

  // TTL File Info
  static const String ttlSuffix = ".ttl";
  static const String commonFileName = "common";

  // Geo File Keys & Survey File Keys
  static const String latitudeKey = "latitude";
  static const String longitudeKey = "longitude";
  static const String q1Key = "strengthCheck";
  static const String q2Key = "fasting";
  static const String q3Key = "postprandial";
  static const String q4Key = "systolic";
  static const String q5Key = "diastolic";
  static const String q6Key = "weight";
  static const String obTimeKey = "obTime";
  static const String deviceKey = "device";

  // Common File Keys
  static const String lastObTimeKey = "lastObTime";

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
  static const String q1Text = "Are you lacking in strength today?";
  static const String q2Text = "What's your fasting blood glucose today?";
  static const String q3Text = "What's your postprandial blood glucose today?";
  static const String q4Text = "What's your systolic today?";
  static const String q5Text = "What's your diastolic today?";
  static const String q6Text = "What's your weight today?";

  // Geo Info Saving Interval (seconds)
  static const int interval = 60;

  // The Notify Hour Every Day (hour)
  static const int notificationHour = 9;

  // Shared Preference Keys
  static const String lastScheduledDateKey = "lastScheduledDate";
  static const String lastInputURLKey = "lastInputURL";

  // Survey CheckBox Level
  static const double optionNo = 2;
  static const double optionMild = 4;
  static const double optionModerate = 6;
  static const double optionSevere = 8;
  static const double optionNull = 0;
  static const double optionMaxY = 10;

  // Survey Charts
  static const int barNumber = 7;
  static const int lineNumber = 7;
  static const double fastingMinY = 30;
  static const double postprandialMinY = 30;
  static const double diastolicMinY = 25;
  static const double weightMinY = 10;
  static const double systolicMinY = 45;
  static const String defaultObTime = "N/A";
  static const double toolTipNoneVal = -1;
  static final Map<double, String> toolTipDoubleToStrMap = {
    optionNull: "Null",
    optionNo: "No",
    optionMild: "Mild",
    optionModerate: "Mod",
    optionSevere: "Sev"
  };

  // Map Parameters
  static const double maxZoom = 18;
  static const double minZoom = 3;
  static const double defaultZoom = 16.5;
  static const double stepZoom = 1.5;

  // Background Tasks
  static const String simplePeriodicTask =
      "onionoino.klee.klee.simplePeriodicTask";

  // Radio List Hint Text
  static const String radioListHintText =
      "0 - No | 1 - Mild | 2 - Moderate | 3 - Severe";

  // Index Page Instructions
  static const String subTitle1 = "Home Page:";
  static const String subTitle2 = "Map Page:";
  static const String subTitle3 = "Survey Page:";
  static const String subTitle4 = "POD Page:";
  static const String indexPageInstructionText1 =
      "The portal of this app, you can view instructions and set your enc-key here";
  static const String indexPageInstructionText2 =
      "The page you can locate & collect & modify your exact geographical information into your POD";
  static const String indexPageInstructionText3 =
      "You can submit your health report here everyday";
  static const String indexPageInstructionText4 =
      "A useful data exhibition and analysis interface";

  // Week Day Name
  static const Map<int, String> weekMap = {
    1: "MON",
    2: "TUE",
    3: "WED",
    4: "THU",
    5: "FRI",
    6: "SAT",
    7: "SUN",
  };
}
