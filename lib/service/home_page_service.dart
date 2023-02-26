import 'package:common_utils/common_utils.dart';
import 'package:klee/net/home_page_net.dart';
import 'package:klee/utils/constants.dart';
import 'package:klee/utils/geo_utils.dart';
import 'package:klee/utils/solid_utils.dart';
import 'package:klee/utils/survey_utils.dart';
import 'package:klee/utils/time_utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// the model-view layer of home page, including all services the very view layer needs
class HomePageService {
  final HomePageNet homePageNet = HomePageNet();

  /// the method is to save the answered survey information into a POD
  /// @param answer1 - q1's answer
  ///        answer2 - q2's answer
  ///        answer3 - q3's answer
  ///        answer4 - q4's answer
  ///        answer5 - q5's answer
  ///        answer6 - q6's answer
  ///        authData - the authentication Data received after login
  ///        dateTime - the timestamp collected when submitting the survey
  /// @return isSuccess - TRUE is success and FALSE is failure
  Future<bool> saveSurveyInfo(
      String answer1,
      String answer2,
      String answer3,
      String answer4,
      String answer5,
      String answer6,
      Map<dynamic, dynamic>? authData,
      DateTime dateTime) async {
    Map<String, dynamic> podInfo = SolidUtils.parseAuthData(authData);
    String? accessToken = podInfo[Constants.accessToken];
    String? webId = podInfo[Constants.webId];
    String? podURI = podInfo[Constants.podURI];
    String? containerURI = podInfo[Constants.containerURI];
    String? surveyContainerURI = podInfo[Constants.surveyContainerURI];
    dynamic rsa = podInfo[Constants.rsa];
    dynamic pubKeyJwk = podInfo[Constants.pubKeyJwk];
    Map<String, String> surveyInfo = SurveyUtils.getFormattedSurvey(
        answer1, answer2, answer3, answer4, answer5, answer6);
    try {
      if (!SolidUtils.isContainerExist(
          await homePageNet.readFile(podURI!, accessToken!, rsa, pubKeyJwk),
          Constants.containerName)) {
        await homePageNet.mkdir(
            podURI, accessToken, rsa, pubKeyJwk, Constants.containerName);
      }
      if (!SolidUtils.isContainerExist(
          await homePageNet.readFile(
              containerURI!, accessToken, rsa, pubKeyJwk),
          Constants.surveyContainerName)) {
        await homePageNet.mkdir(containerURI, accessToken, rsa, pubKeyJwk,
            Constants.surveyContainerName);
      }
      String todayContainerName =
          Constants.mark + TimeUtils.getFormattedTimeYYYYmmDD(dateTime);
      if (!SolidUtils.isContainerExist(
          await homePageNet.readFile(
              surveyContainerURI!, accessToken, rsa, pubKeyJwk),
          todayContainerName)) {
        await homePageNet.mkdir(surveyContainerURI, accessToken, rsa, pubKeyJwk,
            todayContainerName);
      }
      String todayContainerURI = "$surveyContainerURI$todayContainerName/";
      String curRecordFileName =
          Constants.mark + TimeUtils.getFormattedTimeHHmmSS(dateTime);
      await homePageNet.touch(
          todayContainerURI, accessToken, rsa, pubKeyJwk, curRecordFileName);
      String curRecordFileURI = SolidUtils.genCurRecordFileURI(
          todayContainerURI, curRecordFileName, webId!);
      String sparqlQuery;
      String predicate;
      // start saving
      surveyInfo.forEach((subject, value) async {
        predicate = SolidUtils.genPredicate(subject);
        sparqlQuery = SolidUtils.genSparqlQuery(
            Constants.insert, webId, predicate, surveyInfo[subject]!, null);
        await homePageNet.updateFile(
            curRecordFileURI, accessToken, rsa, pubKeyJwk, sparqlQuery);
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Constants.lastSurveyDateKey,
          TimeUtils.getFormattedTimeYYYYmmDD(dateTime));
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
  Future<bool> saveGeoInfo(
      LatLng latLng, Map<dynamic, dynamic>? authData, DateTime dateTime) async {
    Map<String, dynamic> podInfo = SolidUtils.parseAuthData(authData);
    String? accessToken = podInfo[Constants.accessToken];
    String? webId = podInfo[Constants.webId];
    String? podURI = podInfo[Constants.podURI];
    String? containerURI = podInfo[Constants.containerURI];
    String? geoContainerURI = podInfo[Constants.geoContainerURI];
    dynamic rsa = podInfo[Constants.rsa];
    dynamic pubKeyJwk = podInfo[Constants.pubKeyJwk];
    Map<String, String> positionInfo = GeoUtils.getFormattedPosition(latLng);
    try {
      if (!SolidUtils.isContainerExist(
          await homePageNet.readFile(podURI!, accessToken!, rsa, pubKeyJwk),
          Constants.containerName)) {
        await homePageNet.mkdir(
            podURI, accessToken, rsa, pubKeyJwk, Constants.containerName);
      }
      if (!SolidUtils.isContainerExist(
          await homePageNet.readFile(
              containerURI!, accessToken, rsa, pubKeyJwk),
          Constants.geoContainerName)) {
        await homePageNet.mkdir(containerURI, accessToken, rsa, pubKeyJwk,
            Constants.geoContainerName);
      }
      String todayContainerName =
          Constants.mark + TimeUtils.getFormattedTimeYYYYmmDD(dateTime);
      if (!SolidUtils.isContainerExist(
          await homePageNet.readFile(
              geoContainerURI!, accessToken, rsa, pubKeyJwk),
          todayContainerName)) {
        await homePageNet.mkdir(
            geoContainerURI, accessToken, rsa, pubKeyJwk, todayContainerName);
      }
      String todayContainerURI = "$geoContainerURI$todayContainerName/";
      String curRecordFileName =
          Constants.mark + TimeUtils.getFormattedTimeHHmmSS(dateTime);
      await homePageNet.touch(
          todayContainerURI, accessToken, rsa, pubKeyJwk, curRecordFileName);
      String curRecordFileURI = SolidUtils.genCurRecordFileURI(
          todayContainerURI, curRecordFileName, webId!);
      String sparqlQuery;
      String predicate;
      // start saving
      positionInfo.forEach((subject, value) async {
        predicate = SolidUtils.genPredicate(subject);
        sparqlQuery = SolidUtils.genSparqlQuery(
            Constants.insert, webId, predicate, positionInfo[subject]!, null);
        await homePageNet.updateFile(
            curRecordFileURI, accessToken, rsa, pubKeyJwk, sparqlQuery);
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
