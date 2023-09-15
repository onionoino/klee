/// Provide a util class to operate local device files
///
/// Copyright (C) 2023 The Authors
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Bowen Yang

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
