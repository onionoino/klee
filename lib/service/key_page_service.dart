import '../utils/constants.dart';
import '../utils/encrpt_utils.dart';
import '../utils/solid_utils.dart';

class KeyPageService {
  Future<bool> checkAndSetEncKey(Map<dynamic, dynamic>? authData, String encKeyText) async {
    Map<String, dynamic> podInfo = SolidUtils.parseAuthData(authData);
    String? webId = podInfo[Constants.webId];
    return EncryptUtils.checkAndSet(authData!, encKeyText, webId!);
  }
}