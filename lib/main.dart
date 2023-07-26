import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:klee/ui/login_page/login_page.dart';
import 'package:klee/utils/geo_utils.dart';

/// main portal of this very application
/// @Author Bowen Yang
void main() async {
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
