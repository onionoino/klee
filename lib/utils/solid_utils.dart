import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:klee/model/survey_info.dart';
import 'package:klee/utils/constants.dart';
import 'package:rdflib/rdflib.dart';

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

  static SurveyInfo parseSurveyFile(String content) {
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
      if (line.contains(Constants.q1Key)) {
        surveyInfo
            .setIsCough(val.replaceAll("\".", "").replaceAll("\";", "").trim());
      } else if (line.contains(Constants.q2Key)) {
        surveyInfo.setIsSoreThroat(
            val.replaceAll("\".", "").replaceAll("\";", "").trim());
      } else if (line.contains(Constants.q3Key)) {
        surveyInfo.setTemperature(
            val.replaceAll("\".", "").replaceAll("\";", "").trim());
      } else if (line.contains(Constants.q4Key)) {
        surveyInfo.setSystolic(
            val.replaceAll("\".", "").replaceAll("\";", "").trim());
      } else if (line.contains(Constants.q5Key)) {
        surveyInfo.setDiastolic(
            val.replaceAll("\".", "").replaceAll("\";", "").trim());
      } else if (line.contains(Constants.q6Key)) {
        surveyInfo.setHeartRate(
            val.replaceAll("\".", "").replaceAll("\";", "").trim());
      } else if (line.contains(Constants.obTimeKey)) {
        surveyInfo
            .setObTime(val.replaceAll("\".", "").replaceAll("\";", "").trim());
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
