/// Provide some constants used in this project
///
/// Copyright (C) 2023 The Authors
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Bowen Yang, Ye Duan

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// this class contains some constants used in this project
class Constants {
  // Page Indices
  static const int indexPage = 0;
  static const int surveyPage = 1;
  static const int podPage = 2;
  static const int dataPage = 3;
  static const int mapPage = 4;
  static const int settingsPage = 5; // Add this line

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
  static const String q7Key = "heartRate";
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
  static const String q4Text = "What's your systolic measurement today?";
  static const String q5Text = "What's your diastolic measurement today?";
  static const String q6Text = "What's your weight today?";
  static const String q7Text = "What's your heart rate today?";

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
  static const double optionMaxY = 8;

  // Survey Charts
  static const int barNumber = 15;
  static const int lineNumber = 15;
  static const double fastingMinY = 0; //30
  static const double postprandialMinY = 0; //30
  static const double diastolicMinY = 0; //25
  static const double weightMinY = 0; //10
  static const double systolicMinY = 0; //45
  static const double heartRateMinY = 0; //30
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
      "com.togaware.securedialog.simplePeriodicTask";

  // Radio List Hint Text
  static const String radioListHintText =
      "0 - No | 1 - Mild | 2 - Moderate | 3 - Severe";

  // Index Page Instructions
  static const String subTitle1 = "Home Page:";
  static const String subTitle2 = "Map Page:";
  static const String subTitle3 = "Survey Page:";
  static const String subTitle4 = "Chart Page:";
  static const String subTitle5 = "Settings Page:";
  static const String subTitle6 = "Data Page:";

  static const String indexPageInstructionText1 =
      "The portal of this app, you can view "
      "instructions and set your enc-key here";
  static const String indexPageInstructionText2 =
      "Here you can locate, collect, and modify "
      "your location information into your POD.";
  static const String indexPageInstructionText3 =
      "You can submit your health report here everyday.";
  static const String indexPageInstructionText4 =
      "A useful data exhibition and analysis interface.";
  static const String indexPageInstructionText5 =
      "You can check your information here and logout.";
  static const String indexPageInstructionText6 =
      "Your data from the POD is available to be "
      "reviewed and updated.";

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
  // Background color
  static final Color? backgroundColor = Colors.orange[50];
}
