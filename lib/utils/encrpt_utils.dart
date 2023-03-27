import 'package:solid_encrypt/solid_encrypt.dart';

import 'global.dart';

class EncryptUtils {
  static EncryptClient? _client;

  static Future<EncryptClient?> getClient(Map authData, String webId) async {
    if (_client == null) {
      _client = EncryptClient(authData, webId);
      if(await _client!.checkEncSetup() == false) {
        await _client?.setupEncKey(Global.encryptKey);
      }
    }
    return _client;
  }

  static Future<void> revoke() async {
    if (_client == null) {
      return;
    }
    await _client?.revokeEnc(Global.encryptKey);
    _client == null;
  }

  static String? encode(String text, EncryptClient? encryptClient) {
    return encryptClient?.encryptVal(Global.encryptKey, text);
  }

  static String? decode(String code, EncryptClient? encryptClient) {
    return encryptClient?.decryptVal(Global.encryptKey, code);
  }
}
