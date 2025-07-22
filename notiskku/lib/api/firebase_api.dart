import 'package:flutter/foundation.dart'; // debugPrint 포함
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
    if (kIsWeb) {
      debugPrint('웹 환경에서는 Firebase Messaging을 초기화하지 않습니다.');
      return;
    }

    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();
    debugPrint('Token: $fCMToken'); // 실제 앱 운영 시 DB에 저장

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(message);
    });

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
