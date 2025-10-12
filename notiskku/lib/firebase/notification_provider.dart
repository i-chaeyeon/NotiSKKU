import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notiskku/screen/screen_main_tabs.dart';

import '../main.dart'; // navigatorKey

class NotificationProvider extends ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  RemoteMessage? _message;

  RemoteMessage? get message => _message;

  Future<void> init() async {
    if (kIsWeb) {
      debugPrint('웹 환경에서는 Firebase Messaging을 초기화하지 않습니다.');
      return;
    }

    // 권한 요청 (Android 13+ 중요)
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 토큰 확인(필요 시 서버 저장)
    final token = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $token');

    // ★ 백그라운드 핸들러는 main()에서만 등록합니다 (여기서 금지)

    // 포그라운드 메시지
    FirebaseMessaging.onMessage.listen((msg) {
      debugPrint('Foreground: ${msg.notification?.title}');
      _message = msg;
      notifyListeners();
    });

    // 앱이 열려있는 상태에서 알림 클릭
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      debugPrint('onMessageOpenedApp: ${msg.data}');
      _message = msg;
      _navigateToScreen();
    });

    // 종료 상태에서 알림 클릭해 진입
    final initialMsg = await _firebaseMessaging.getInitialMessage();
    if (initialMsg != null) {
      _message = initialMsg;
      _navigateToScreen();
    }
  }

  void _navigateToScreen() {
    // 프레임 끝에서 내비게이션
    Future.microtask(() {
      final nav = navigatorKey.currentState;
      if (nav == null) return;
      nav.push(MaterialPageRoute(builder: (_) => const ScreenMainTabs()));
    });
  }
}
