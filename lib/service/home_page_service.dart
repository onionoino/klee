import 'package:common_utils/common_utils.dart';
import 'package:klee/net/home_page_net.dart';
import 'package:klee/utils/constants.dart';
import 'package:klee/utils/geo_utils.dart';
import 'package:klee/utils/solid_utils.dart';
import 'package:klee/utils/survey_utils.dart';
import 'package:latlong2/latlong.dart';

/// the model-view layer of home page, including all services the very view layer needs
class HomePageService {
  final HomePageNet homePageNet = HomePageNet();

  /// the method is to save the answered survey information into a POD
  /// @param
  /// @return isSuccess - TRUE is success and FALSE is failure
  Future<bool> saveSurveyInfo(
      String answer1, String answer2, String answer3, Map<dynamic, dynamic>? authData, DateTime dateTime) async {
    Map<String, dynamic> podInfo = SolidUtils.parseAuthData(authData);
    String? accessToken = podInfo[Constants.accessToken];
    String? webId = podInfo[Constants.webId];
    String? podURI = podInfo[Constants.podURI];
    String? containerURI = podInfo[Constants.containerURI];
    String? kleeFileURI = podInfo[Constants.kleeFileURI];
    dynamic rsa = podInfo[Constants.rsa];
    dynamic pubKeyJwk = podInfo[Constants.pubKeyJwk];
    Map<String, String> surveyInfo = SurveyUtils.getFormattedSurvey(answer1, answer2, answer3, dateTime);
    try {
      if (!SolidUtils.isContainerExist(
          await homePageNet.readFile(podURI!, accessToken!, rsa, pubKeyJwk))) {
        homePageNet.mkdir(podURI, accessToken, rsa, pubKeyJwk, Constants.containerName);
      }
      if (!SolidUtils.isKleeFileExist(
          await homePageNet.readFile(containerURI!, accessToken, rsa, pubKeyJwk))) {
        homePageNet.touch(containerURI, accessToken, rsa, pubKeyJwk, Constants.kleeFileName);
      }
      String content = await homePageNet.readFile(kleeFileURI!, accessToken, rsa, pubKeyJwk);
      String sparqlQuery;
      SolidUtils.parseKleeFile(content).forEach((subject, prevObject) {
        if (Constants.kleeFileSurveyKeyList.contains(subject)) {
          String predicate = SolidUtils.genPredicate(subject);
          if (prevObject == Constants.none) {
            sparqlQuery = SolidUtils.genSparqlQuery(
                Constants.insert, webId!, predicate, surveyInfo[subject]!, null);
          } else {
            sparqlQuery = SolidUtils.genSparqlQuery(
                Constants.update, webId!, predicate, surveyInfo[subject]!, prevObject);
          }
          homePageNet.updateFile(kleeFileURI, accessToken, rsa, pubKeyJwk, sparqlQuery);
        }
      });
    } catch (e) {
      LogUtil.e("Error on saving survey information");
      return false;
    }

    return true;
  }

  /// the method is to save the geographical information into a POD
  /// @param latLng - geographical information collected from the device
  ///        authData - the authentication Data received after login
  ///        dateTime - the timestamp collected along with geographical information collection
  /// @return isSuccess - TRUE is success and FALSE is failure
  Future<bool> saveGeoInfo(LatLng latLng, Map<dynamic, dynamic>? authData, DateTime dateTime) async {
    Map<String, dynamic> podInfo = SolidUtils.parseAuthData(authData);
    String? accessToken = podInfo[Constants.accessToken];
    String? webId = podInfo[Constants.webId];
    String? podURI = podInfo[Constants.podURI];
    String? containerURI = podInfo[Constants.containerURI];
    String? kleeFileURI = podInfo[Constants.kleeFileURI];
    dynamic rsa = podInfo[Constants.rsa];
    dynamic pubKeyJwk = podInfo[Constants.pubKeyJwk];
    Map<String, String> positionInfo = GeoUtils.getFormattedPosition(latLng, dateTime);
    try {
      if (!SolidUtils.isContainerExist(
          await homePageNet.readFile(podURI!, accessToken!, rsa, pubKeyJwk))) {
        homePageNet.mkdir(podURI, accessToken, rsa, pubKeyJwk, Constants.containerName);
      }
      if (!SolidUtils.isKleeFileExist(
          await homePageNet.readFile(containerURI!, accessToken, rsa, pubKeyJwk))) {
        homePageNet.touch(containerURI, accessToken, rsa, pubKeyJwk, Constants.kleeFileName);
      }
      String content = await homePageNet.readFile(kleeFileURI!, accessToken, rsa, pubKeyJwk);
      String sparqlQuery;
      SolidUtils.parseKleeFile(content).forEach((subject, prevObject) {
        if (Constants.kleeFileGeoKeyList.contains(subject)) {
          String predicate = SolidUtils.genPredicate(subject);
          if (prevObject == Constants.none) {
            sparqlQuery = SolidUtils.genSparqlQuery(
                Constants.insert, webId!, predicate, positionInfo[subject]!, null);
          } else {
            sparqlQuery = SolidUtils.genSparqlQuery(
                Constants.update, webId!, predicate, positionInfo[subject]!, prevObject);
          }
          homePageNet.updateFile(kleeFileURI, accessToken, rsa, pubKeyJwk, sparqlQuery);
        }
      });
    } catch (e) {
      LogUtil.e("Error on saving geographical information");
      return false;
    }
    return true;
  }

  /// the method is to log out from a logged-in status, once log out, users need to reenter the username and password
  /// @param logoutUrl - the logout url parsed from authentication data
  /// @return void
  void logout(String logoutURL) async {
    homePageNet.logout(logoutURL);
  }
}
