import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// a temporary class for testing, will be deleted in the future version
class FileAction {
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
