// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태관리
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 기기별 화면 크기 대응
import 'package:flutter/services.dart'; // 화면 회전 제어용 패키지

// Firebase 관련
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase/firebase_options.dart';
import 'firebase/background_handler.dart';

// 전역 인스턴스 초기화 위젯 + 전역 리스너
import 'package:notiskku/firebase/fcm_initializer.dart';
import 'package:notiskku/firebase/foreground_message_listener.dart';

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

  // (중요) 여기서 NotificationProvider().init() 직접 호출하지 않음
  // await NotificationProvider().init();  // ← 삭제

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
          // 전역 초기화 + 전역 포그라운드 리스너
          builder:
              (context, child) => Stack(
                children: [
                  if (child != null) child,
                  const FcmInitializer(), // ← 전역 1회 init(Provider 인스턴스로)
                  const ForegroundMessageListener(), // ← 전역 SnackBar 리스너
                ],
              ),
          home: const ScreenLogoIntro(),
        );
      },
    );
  }
}
