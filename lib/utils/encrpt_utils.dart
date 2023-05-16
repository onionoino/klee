import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:solid_encrypt/solid_encrypt.dart';

import 'global.dart';

class EncryptUtils {
  static EncryptClient? _client;

  static Future<EncryptClient?> getClient(Map authData, String webId) async {
    return _client;
  }

  static Future<bool> checkAndSet(
      Map authData, String encKeyText, String webId) async {
    try {
      _client ??= EncryptClient(authData, webId);
      String encKey =
          sha256.convert(utf8.encode(encKeyText)).toString().substring(0, 32);
      if (await _client!.checkEncSetup() == false) {
        await _client?.setupEncKey(encKey);
        Global.encryptKey = encKey;
        return true;
      } else {
        if (await _client!.verifyEncKey(encKey)) {
          Global.encryptKey = encKey;
          return true;
        }
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<void> revoke() async {
    if (_client == null) {
      return;
    }
    await _client?.revokeEnc(Global.encryptKey);
    _client == null;
  }

  static String? encode(String text, EncryptClient encryptClient) {
    return encryptClient?.encryptVal(Global.encryptKey, text);
  }

  static String? decode(String code, EncryptClient encryptClient) {
    return encryptClient?.decryptVal(Global.encryptKey, code);
  }
}
