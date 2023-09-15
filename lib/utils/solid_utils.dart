/// Provide a utility class for managing solid server operations
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

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:securedialog/model/survey_info.dart';
import 'package:securedialog/utils/constants.dart';
import 'package:securedialog/utils/encrpt_utils.dart';
import 'package:rdflib/rdflib.dart';
import 'package:solid_encrypt/solid_encrypt.dart';

/// this class is a util class related to solid server affairs
class SolidUtils {
  static String? getLastObTime(String content) {
    List<String> lines = content.split("\n");
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      if (line.trim() == "") {
        continue;
      }
      if (line.contains(Constants.lastObTimeKey)) {
        return line
            .split(" \"")[1]
            .replaceAll("\".", "")
            .replaceAll("\";", "")
            .trim();
      }
    }
    return null;
  }

  static SurveyInfo parseSurveyFile(
      String content, EncryptClient encryptClient) {
    SurveyInfo surveyInfo = SurveyInfo();
    List<String> lines = content.split("\n");
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String val = "";
      if (line.contains(" \"")) {
        val = line.split(" \"")[1];
      } else {
        continue;
      }
      if (line.contains(EncryptUtils.encode(Constants.q1Key, encryptClient)!)) {
        surveyInfo.setStrength(EncryptUtils.decode(
            val.replaceAll("\".", "").replaceAll("\";", "").trim(),
            encryptClient)!);
      } else if (line
          .contains(EncryptUtils.encode(Constants.q2Key, encryptClient)!)) {
        surveyInfo.setFasting(EncryptUtils.decode(
            val.replaceAll("\".", "").replaceAll("\";", "").trim(),
            encryptClient)!);
      } else if (line
          .contains(EncryptUtils.encode(Constants.q3Key, encryptClient)!)) {
        surveyInfo.setPostprandial(EncryptUtils.decode(
            val.replaceAll("\".", "").replaceAll("\";", "").trim(),
            encryptClient)!);
      } else if (line
          .contains(EncryptUtils.encode(Constants.q4Key, encryptClient)!)) {
        surveyInfo.setSystolic(EncryptUtils.decode(
            val.replaceAll("\".", "").replaceAll("\";", "").trim(),
            encryptClient)!);
      } else if (line
          .contains(EncryptUtils.encode(Constants.q5Key, encryptClient)!)) {
        surveyInfo.setDiastolic(EncryptUtils.decode(
            val.replaceAll("\".", "").replaceAll("\";", "").trim(),
            encryptClient)!);
      } else if (line
          .contains(EncryptUtils.encode(Constants.q6Key, encryptClient)!)) {
        surveyInfo.setWeight(EncryptUtils.decode(
            val.replaceAll("\".", "").replaceAll("\";", "").trim(),
            encryptClient)!);
      } else if (line
          .contains(EncryptUtils.encode(Constants.q7Key, encryptClient)!)) {
        surveyInfo.setHeartRate(EncryptUtils.decode(
            val.replaceAll("\".", "").replaceAll("\";", "").trim(),
            encryptClient)!);
      } else if (line
          .contains(EncryptUtils.encode(Constants.obTimeKey, encryptClient)!)) {
        surveyInfo.setObTime(EncryptUtils.decode(
            val.replaceAll("\".", "").replaceAll("\";", "").trim(),
            encryptClient)!);
      }
    }
    return surveyInfo;
  }

  static List<String> getSurveyFileNameList(
      String content, String webId, int num) {
    List<String> nameList = [];
    if (_isSolidCommunityHost(webId)) {
      // solid community needs to be parsed differently
      List<String> lines = content.split("\n");
      for (int i = lines.length - 1; i >= 0 && nameList.length < num; i--) {
        String line = lines[i];
        if (line.contains(".ttl>") && !line.contains(".ttl>,")) {
          String fileName = line.substring(1, 19);
          nameList.insert(0, fileName);
        }
      }
    } else {
      Graph graph = Graph();
      graph.parseTurtle(content);
      graph.groups.forEach((key, value) {
        if (nameList.length >= num) {
          return;
        }
        if (key.value.trim() != "") {
          nameList.add(key.value);
        }
      });
    }
    return nameList;
  }

  /// check if the container the app need to use is already exist, if it is, no need to create
  /// a new one, if not, the app need to create a new container
  /// @param content - the content read from the directory of the POD
  /// @param name - specific container name of being checked
  /// @return isExist - TRUE means it exists, FALSE means not
  static bool isContainerExist(String content, String name) {
    return content.contains("$name/") ||
        content.contains("@prefix $name: </$name/>.");
  }

  /// check if the file the app need to use is already exist, if it is, no need to create
  /// a new one, if not, the app need to create a new file
  /// @param content - the content read from the directory of the POD
  /// @param name - specific file name of being checked
  /// @return isExist - TRUE means it exists, FALSE means not
  static bool isFileExist(String content, String name) {
    return content.contains("<$name>") || content.contains("<$name.ttl>");
  }

  /// parse the received authentication data into a map data structure to reduce the repeated parsing
  /// and make it easier to use during the business logic
  /// @param authData - the authentication data get from login procedure
  /// @return parsedAuthData - a <String, dynamic> map that contains necessary data parsed from the original authentication data
  static Map<String, dynamic> parseAuthData(Map<dynamic, dynamic>? authData) {
    String accessToken = authData![Constants.accessToken];
    String webId =
        JwtDecoder.decode(accessToken)[Constants.webId.toLowerCase()];
    String podURI = webId.substring(0, webId.length - 15);
    String containerURI = podURI + Constants.relativeContainerURI;
    String geoContainerURI = containerURI + Constants.relativeGeoContainerURI;
    String surveyContainerURI =
        containerURI + Constants.relativeSurveyContainerURI;
    dynamic rsa = authData[Constants.rsaInfo][Constants.rsa];
    dynamic pubKeyJwk = authData[Constants.rsaInfo][Constants.pubKeyJwk];
    return <String, dynamic>{
      Constants.accessToken: accessToken,
      Constants.webId: webId,
      Constants.rsa: rsa,
      Constants.pubKeyJwk: pubKeyJwk,
      Constants.podURI: podURI,
      Constants.containerURI: containerURI,
      Constants.geoContainerURI: geoContainerURI,
      Constants.surveyContainerURI: surveyContainerURI,
    };
  }

  /// generate a sparql query based on given information
  /// @param action - the action of this sparql query, INSERT/DELETE/UPDATE
  ///        subject - subject in a sparql query
  ///        predicate - predicate in a sparql query
  ///        object - object in a sparql query
  ///        prevObject - only applied to UPDATE action, when updating, the app needs to delete
  ///                     the previous data and insert a new one, so it is necessary to provide
  ///                     a previous value in this query, otherwise will receive a 409 (conflict)
  ///                     error status code
  /// @return sparqlQuery - a sparql query in string format
  static String genSparqlQuery(String action, String subject, String predicate,
      String object, String? prevObject) {
    String query;
    switch (action) {
      case Constants.insert:
        query = "INSERT DATA {<$subject> <$predicate> \"$object\"}";
        break;
      case Constants.delete:
        query = "DELETE DATA {<$subject> <$predicate> \"$object\"}";
        break;
      case Constants.update:
        query =
            "DELETE DATA {<$subject> <$predicate> \"$prevObject\"}; INSERT DATA {<$subject> <$predicate> \"$object\"}";
        break;
      default:
        throw Exception("Invalid action");
    }
    return query;
  }

  /// generate predicate that will be used in genSparqlQuery() method
  /// @param attribute - the attribute user would like to modify
  /// @return predicate - generated predicate
  static String genPredicate(String attribute) {
    return Constants.predicate + attribute;
  }

  /// generate curRecordFileName that will be used in saveSurveyInfo() method
  /// @param todayContainerURI - today's container URI
  ///        curRecordFileName - the record-file-name at this time
  ///        webId - user's webId
  /// @return curRecordFileURI - generated record-file-URI at this time
  static String genCurRecordFileURI(
      String todayContainerURI, String curRecordFileName, String webId) {
    if (_isSolidCommunityHost(webId)) {
      return todayContainerURI + curRecordFileName + Constants.ttlSuffix;
    } else {
      return todayContainerURI + curRecordFileName;
    }
  }

  static bool _isSolidCommunityHost(String webId) {
    return webId.contains("solidcommunity");
  }
}
