/// Personal diabetes management tool with privacy
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
/// Authors: Bowen Yang, Ye Duan, Graham Williams

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:universal_io/io.dart' show Platform;
import 'package:window_manager/window_manager.dart';

import 'package:securedialog/ui/login_page/login_page.dart';
import 'package:securedialog/utils/geo_utils.dart';

/// Main entry point for the application.

void main() async {
  // Identify if Desktop or Mobile app.

  bool isDesktop = Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  // Tune the window manager before runApp to avoid a lag in the UI. For desktop
  // (non-web) versions re-size to mimic mobile (as the main target platform).

  if (isDesktop && !kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();

    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      alwaysOnTop: true,
      // The size is overriden in the first instance by linux/my_application.cc
      // but then does has effect when Retarting the app.
      size: Size(450, 700),
      title: "SecureDiaLog - Diabetic Health",
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setAlwaysOnTop(false);
    });
  }

  WidgetsFlutterBinding.ensureInitialized();
  // init permissions
  AwesomeNotifications().initialize(
      null, //icon is null right now
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Colors.blueAccent,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  GeoUtils.getCurrentLocation();
  runApp(const SecureDiaLog());
}

class SecureDiaLog extends StatelessWidget {
  const SecureDiaLog({super.key});

  // This widget is the root of this application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SecureDiaLog",
      theme: ThemeData(
        colorScheme: const ColorScheme.light().copyWith(
            primary: Color(int.parse("e74c3c", radix: 16) | 0xFF000000)),
      ),
      home: const LoginPage(),
    );
  }
}
