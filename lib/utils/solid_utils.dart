import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:klee/utils/constants.dart';

/// this class is a util class related to solid server affairs
class SolidUtils {
  /// check if the container the app need to use is already exist, if it is, no need to create
  /// a new one, if not, the app need to create a new container in the root directory of the POD
  /// @param content - the content read from the root directory of the POD
  /// @return isExist - TRUE means it exists, FALSE means not
  static bool isContainerExist(String content) {
    return content.contains("@prefix klee: </klee/>.");
  }

  /// check if the file the app need to use is already exist, if it is, no need to create
  /// a new one, if not, the app need to create a new file in a specific container
  /// @param content - the content read from the specific container
  /// @return isExist - TRUE means it exists, FALSE means not
  static bool isKleeFileExist(String content) {
    return content.contains("<klee.ttl>");
  }

  /// parse the received authentication data into a map data structure to reduce the repeated parsing
  /// and make it easier to use during the business logic
  /// @param authData - the authentication data get from login procedure
  /// @return parsedAuthData - a <String, dynamic> map that contains necessary data parsed from the original authentication data
  static Map<String, dynamic> parseAuthData(Map<dynamic, dynamic>? authData) {
    String accessToken = authData![Constants.accessToken];
    String webId = JwtDecoder.decode(accessToken)[Constants.webId.toLowerCase()];
    String podURI = webId.substring(0, webId.length - 15);
    String containerURI = podURI + Constants.relativeContainerURI;
    String kleeFileURI = containerURI + Constants.relativeKleeFileURI;
    dynamic rsa = authData[Constants.rsaInfo][Constants.rsa];
    dynamic pubKeyJwk = authData[Constants.rsaInfo][Constants.pubKeyJwk];
    return <String, dynamic>{
      Constants.accessToken: accessToken,
      Constants.webId: webId,
      Constants.rsa: rsa,
      Constants.pubKeyJwk: pubKeyJwk,
      Constants.podURI: podURI,
      Constants.containerURI: containerURI,
      Constants.kleeFileURI: kleeFileURI,
    };
  }

  /// parse the content get from the file, it may be optimized later
  /// @param content - content fetched from the klee.ttl file in the POD
  /// @return parsedFile - a <String, String> map that contains necessary data parsed from the file
  static Map<String, String> parseKleeFile(String content) {
    List<String> lineList = content.split("\n");
    Map<String, String> parsedInfo = {
      Constants.latitude: Constants.none,
      Constants.longitude: Constants.none,
      Constants.dateTime: Constants.none,
    };
    for (String line in lineList) {
      if (line.contains(Constants.latitude)) {
        parsedInfo[Constants.latitude] = line
            .split(Constants.latitude)[1]
            .replaceAll("\".", "")
            .replaceAll("\";", "")
            .replaceAll("\"", "")
            .trim();
      } else if (line.contains(Constants.longitude)) {
        parsedInfo[Constants.longitude] = line
            .split(Constants.longitude)[1]
            .replaceAll("\".", "")
            .replaceAll("\";", "")
            .replaceAll("\"", "")
            .trim();
      } else if (line.contains(Constants.dateTime)) {
        parsedInfo[Constants.dateTime] = line
            .split(Constants.dateTime)[1]
            .replaceAll("\".", "")
            .replaceAll("\";", "")
            .replaceAll("\"", "")
            .trim();
      }
    }
    return parsedInfo;
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
  static String genSparqlQuery(
      String action, String subject, String predicate, String object, String? prevObject) {
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
            "DELETE DATA {<$subject> <$predicate> \"$prevObject\"} INSERT DATA {<$subject> <$predicate> \"$object\"}";
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
}
