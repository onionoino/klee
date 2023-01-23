import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// this class is a util class to operate local device files
class DeviceFileUtils {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/latlng.txt');
  }

  Future<File> writeContent(String str) async {
    final file = await _localFile;
    return file.writeAsString(str);
  }

  Future<String> readContent() async {
    try {
      final file = await _localFile;
      final content = await file.readAsString();
      return content;
    } catch (e) {
      return '';
    }
  }
}
