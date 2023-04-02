import 'package:common_utils/common_utils.dart';
import 'package:klee/model/geo_info.dart';
import 'package:klee/model/survey_info.dart';
import 'package:klee/net/home_page_net.dart';
import 'package:klee/utils/constants.dart';
import 'package:klee/utils/geo_utils.dart';
import 'package:klee/utils/solid_utils.dart';
import 'package:klee/utils/survey_utils.dart';
import 'package:klee/utils/time_utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:solid_encrypt/solid_encrypt.dart';

import '../utils/encrpt_utils.dart';

/// the model-view layer of home page, including all services the very view layer needs
class HomePageService {
  final HomePageNet homePageNet = HomePageNet();

  /// this method is to get a list of survey info from a POD
  Future<List<SurveyInfo>?> getSurveyInfoList(
      int num, Map<dynamic, dynamic>? authData) async {
    List<SurveyInfo> surveyInfoList = [];
    Map<String, dynamic> podInfo = SolidUtils.parseAuthData(authData);
    String? accessToken = podInfo[Constants.accessToken];
    String? webId = podInfo[Constants.webId];
    String? podURI = podInfo[Constants.podURI];
    String? containerURI = podInfo[Constants.containerURI];
    String? surveyContainerURI = podInfo[Constants.surveyContainerURI];
    dynamic rsa = podInfo[Constants.rsa];
    dynamic pubKeyJwk = podInfo[Constants.pubKeyJwk];
    EncryptClient? encryptClient = await EncryptUtils.getClient(authData!, webId!);
    try {
      if (!SolidUtils.isContainerExist(
          await homePageNet.readFile(podURI!, accessToken!, rsa, pubKeyJwk),
          Constants.containerName)) {
        return null;
      }
      if (!SolidUtils.isContainerExist(
          await homePageNet.readFile(
              containerURI!, accessToken, rsa, pubKeyJwk),
          Constants.surveyContainerName)) {
        return null;
      }
      String surveyContainerContent = await homePageNet.readFile(
          surveyContainerURI!, accessToken, rsa, pubKeyJwk);
      List<String> fileNameList =
          SolidUtils.getSurveyFileNameList(surveyContainerContent, webId, num);
      for (int i = 0; i < fileNameList.length; i++) {
        String fileName = fileNameList[i];
        String fileURI = surveyContainerURI + fileName;
        String fileContent =
            await homePageNet.readFile(fileURI, accessToken, rsa, pubKeyJwk);
        SurveyInfo surveyInfo = SolidUtils.parseSurveyFile(fileContent, encryptClient!);
        surveyInfoList.add(surveyInfo);
      }
    } catch (e) {
      LogUtil.e("Error on fetching survey data");
      return null;
    }
    if (surveyInfoList.length < num) {
      for (int i = surveyInfoList.length; i < num; i++) {
        surveyInfoList.add(SurveyInfo());
      }
    }
    return surveyInfoList;
  }

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
    EncryptClient? encryptClient = await EncryptUtils.getClient(authData!, webId!);
    Map<String, String> surveyInfo = await SurveyUtils.getFormattedSurvey(
        answer1, answer2, answer3, answer4, answer5, answer6, dateTime, encryptClient!);
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
      String curSurveyFileName = TimeUtils.getFormattedTimeYYYYmmDD(dateTime) +
          TimeUtils.getFormattedTimeHHmmSS(dateTime);
      await homePageNet.touch(
          surveyContainerURI!, accessToken, rsa, pubKeyJwk, curSurveyFileName);
      String curRecordFileURI = SolidUtils.genCurRecordFileURI(
          surveyContainerURI, curSurveyFileName, webId);
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
      setLastSurveyTime(podInfo, TimeUtils.getFormattedTimeYYYYmmDDHHmmSS(dateTime));
    } catch (e) {
      LogUtil.e("Error on saving survey information");
      return false;
    }
    return true;
  }

  Future<void> setLastSurveyTime(
      Map<String, dynamic> podInfo, String obTime) async {
    String? accessToken = podInfo[Constants.accessToken];
    String? webId = podInfo[Constants.webId];
    String? containerURI = podInfo[Constants.containerURI];
    dynamic rsa = podInfo[Constants.rsa];
    dynamic pubKeyJwk = podInfo[Constants.pubKeyJwk];
    if (!SolidUtils.isFileExist(
        await homePageNet.readFile(containerURI!, accessToken!, rsa, pubKeyJwk),
        Constants.commonFileName)) {
      await homePageNet.touch(
          containerURI, accessToken, rsa, pubKeyJwk, Constants.commonFileName);
    }
    String commonFileURI = SolidUtils.genCurRecordFileURI(
        containerURI, Constants.commonFileName, webId!);
    String content =
        await homePageNet.readFile(commonFileURI, accessToken, rsa, pubKeyJwk);
    String? lastObTime = SolidUtils.getLastObTime(content);
    String subject = Constants.lastObTimeKey;
    String predicate = SolidUtils.genPredicate(subject);
    String sparqlQuery;
    if (lastObTime == null) {
      sparqlQuery = SolidUtils.genSparqlQuery(
          Constants.insert, subject, predicate, obTime, null);
    } else {
      sparqlQuery = SolidUtils.genSparqlQuery(
          Constants.update, subject, predicate, obTime, lastObTime);
    }
    await homePageNet.updateFile(
        commonFileURI, accessToken, rsa, pubKeyJwk, sparqlQuery);
  }

  Future<String> getLastSurveyTime(Map<dynamic, dynamic> authData) async {
    Map<String, dynamic> podInfo = SolidUtils.parseAuthData(authData);
    String? accessToken = podInfo[Constants.accessToken];
    String? webId = podInfo[Constants.webId];
    String? podURI = podInfo[Constants.podURI];
    String? containerURI = podInfo[Constants.containerURI];
    dynamic rsa = podInfo[Constants.rsa];
    dynamic pubKeyJwk = podInfo[Constants.pubKeyJwk];
    try {
      if (!SolidUtils.isContainerExist(
          await homePageNet.readFile(podURI!, accessToken!, rsa, pubKeyJwk),
          Constants.containerName)) {
        return Constants.none;
      }
      if (!SolidUtils.isFileExist(
          await homePageNet.readFile(
              containerURI!, accessToken, rsa, pubKeyJwk),
          Constants.commonFileName)) {
        return Constants.none;
      }
      String commonFileURI = SolidUtils.genCurRecordFileURI(
          containerURI, Constants.commonFileName, webId!);
      String content = await homePageNet.readFile(
          commonFileURI, accessToken, rsa, pubKeyJwk);
      String? lastObTime = SolidUtils.getLastObTime(content);
      if (lastObTime == null) {
        return Constants.none;
      }
      return lastObTime;
    } catch (e) {
      LogUtil.e("Error on fetching lastObTime");
      return Constants.none;
    }
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
    EncryptClient? encryptClient = await EncryptUtils.getClient(authData!, webId!);
    Map<String, String> positionInfo =
    await GeoUtils.getFormattedPosition(latLng, dateTime, encryptClient!);
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
      String todayContainerName = TimeUtils.getFormattedTimeYYYYmmDD(dateTime);
      // todayContainerName = EncryptUtils.encode(todayContainerName, encryptClient)!.replaceAll("=", "%3D");
      if (!SolidUtils.isContainerExist(
          await homePageNet.readFile(
              geoContainerURI!, accessToken, rsa, pubKeyJwk),
          todayContainerName)) {
        await homePageNet.mkdir(
            geoContainerURI, accessToken, rsa, pubKeyJwk, todayContainerName);
      }
      String todayContainerURI = "$geoContainerURI$todayContainerName/";
      String curRecordFileName = TimeUtils.getFormattedTimeHHmmSS(dateTime);
      // curRecordFileName = EncryptUtils.encode(curRecordFileName, encryptClient)!.replaceAll("=", "%3D");
      await homePageNet.touch(
          todayContainerURI, accessToken, rsa, pubKeyJwk, curRecordFileName);
      String curRecordFileURI = SolidUtils.genCurRecordFileURI(
          todayContainerURI, curRecordFileName, webId);
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

  /// the method is to save the geographical information into a POD after recovering from a background status
  /// @param geoInfo - the geo info model
  ///        authData - the authentication Data received after login
  /// @return isSuccess - TRUE is success and FALSE is failure
  Future<bool> saveBgGeoInfo(
      Map<dynamic, dynamic>? authData, GeoInfo geoInfo) async {
    Map<String, dynamic> podInfo = SolidUtils.parseAuthData(authData);
    String? accessToken = podInfo[Constants.accessToken];
    String? webId = podInfo[Constants.webId];
    String? podURI = podInfo[Constants.podURI];
    String? containerURI = podInfo[Constants.containerURI];
    String? geoContainerURI = podInfo[Constants.geoContainerURI];
    dynamic rsa = podInfo[Constants.rsa];
    dynamic pubKeyJwk = podInfo[Constants.pubKeyJwk];
    EncryptClient? encryptClient = await EncryptUtils.getClient(authData!, webId!);
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
      String todayContainerName = geoInfo.date;
      if (!SolidUtils.isContainerExist(
          await homePageNet.readFile(
              geoContainerURI!, accessToken, rsa, pubKeyJwk),
          todayContainerName)) {
        await homePageNet.mkdir(
            geoContainerURI, accessToken, rsa, pubKeyJwk, todayContainerName);
      }
      String todayContainerURI = "$geoContainerURI$todayContainerName/";
      String curRecordFileName = geoInfo.time;
      await homePageNet.touch(
          todayContainerURI, accessToken, rsa, pubKeyJwk, curRecordFileName);
      String curRecordFileURI = SolidUtils.genCurRecordFileURI(
          todayContainerURI, curRecordFileName, webId);
      String sparqlQuery;
      String predicate;
      Map<String, String> positionInfo =
          await GeoUtils.getFormattedPositionFromGeoInfo(geoInfo, encryptClient!);
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
  Future<void> logout(String logoutURL) async {
    EncryptUtils.revoke();
    homePageNet.logout(logoutURL);
  }

  Future<bool> checkAndSetEncKey(Map<dynamic, dynamic>? authData, String encKeyText) async {
    Map<String, dynamic> podInfo = SolidUtils.parseAuthData(authData);
    String? webId = podInfo[Constants.webId];
    return EncryptUtils.checkAndSet(authData!, encKeyText, webId!);
  }
}
