import 'package:flutter/material.dart';
import 'package:klee/ui/login_page/login_page.dart';

/// main portal of this very application
/// @Author Bowen Yang
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of this application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'klee',
      theme: ThemeData(
        colorScheme: const ColorScheme.light()
            .copyWith(primary: Color(int.parse("e74c3c", radix: 16) | 0xFF000000)),
      ),
      home: const LoginPage(),
    );
  }
}
