import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// this class is a util class to operate local device files
class DeviceFileUtils {
  static Future<String> get _localPath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final String path = await _localPath;
    return File("$path/GlobalKey.txt");
  }

  /// write content into local file
  /// @param content - content needs to be written
  /// @return file - file object
  static Future<File> writeContent(String content) async {
    final File file = await _localFile;
    return await file.writeAsString(content);
  }

  /// read content from local file
  /// @return content - content read from the local file
  static Future<String> readContent() async {
    try {
      final File file = await _localFile;
      final String content = await file.readAsString();
      return content;
    } catch (e) {
      return '';
    }
  }

  /// clear current local file
  /// @return void
  static Future<void> clear() async {
    final File file = await _localFile;
    await file.delete();
  }
}
