import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태관리
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 기기별 화면 크기 대응
import 'package:flutter/services.dart'; // 화면 회전 제어용 패키지

// Firebase 관련
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase/firebase_options.dart';
import 'firebase/notification_provider.dart';
import 'firebase/background_handler.dart';

import 'package:notiskku/screen/screen_intro_logo.dart';

final navigatorKey = GlobalKey<NavigatorState>(); // 전역 navigator key

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 백그라운드 메시지 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // 알림 권한 요청 (iOS / Android 13+)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  // 포그라운드/클릭 처리 등 앱 런타임 로직 초기화
  await NotificationProvider().init();

  // 세로 모드 고정 후 앱 실행
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0B5B42),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: const ScreenLogoIntro(),
        );
      },
    );
  }
}
