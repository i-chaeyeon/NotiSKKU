import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notiskku/screen/screen_main_tabs.dart';

import '../main.dart'; // navigatorKey 접근용

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();
    debugPrint('Token: $fCMToken'); // 실제 앱 운영 시 DB에 저장

    // 백그라운드 메시지 핸들러 등록
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // 앱이 열려있을 때 알림 클릭 시
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(message);
    });

    // 앱이 완전히 종료된 상태에서 알림 클릭 시
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  void _handleMessage(RemoteMessage message) {
    Future.delayed(Duration.zero, () {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => ScreenMainTabs()),
      );
    });
  }
}
