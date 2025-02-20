import 'package:flutter/material.dart';
import 'package:notiskku/screen/screen_intro_logo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ProviderScope 추가


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope( // ProviderScope로 앱을 감싸줍니다.
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ScreenLogoIntro(),
    );
  }
}
