import 'package:flutter/foundation.dart'; // debugPrint 포함
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notiskku/screen/screen_main_tabs.dart';

import '../main.dart'; // navigatorKey 접근용

class NotificationProvider extends ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  RemoteMessage? _message;

  RemoteMessage? get message => _message;

  Future<void> init() async {
    if (kIsWeb) {
      debugPrint('웹 환경에서는 Firebase Messaging을 초기화하지 않습니다.');
      return;
    }
    
    // 권한 요청
    await _firebaseMessaging.requestPermission();

    // 토큰 출력
    final token = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $token');

    // 백그라운드 메시지 핸들러 등록
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    // 앱 실행 중 메시지 처리
    FirebaseMessaging.onMessage.listen((msg) {
      debugPrint('Foreground message: ${msg.notification?.title}');
      _message = msg;
      notifyListeners();
    });

    // 앱 열려있을 때 메시지 클릭
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      debugPrint('onMessageOpenedApp: ${msg.data}');
      _message = msg;
      _navigateToScreen();
    });

    // 종료 상태에서 클릭한 메시지 처리
    final initialMsg = await _firebaseMessaging.getInitialMessage();
    if (initialMsg != null) {
      _message = initialMsg;
      _navigateToScreen();
    }
  }

  void _navigateToScreen() {
    Future.microtask(() {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => ScreenMainTabs()),
      );
    });
  }

  Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
    debugPrint('[BG] Title: ${message.notification?.title}');
    debugPrint('[BG] Body: ${message.notification?.body}');
    debugPrint('[BG] Data: ${message.data}');
  }
}

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   debugPrint('Title: ${message.notification?.title}');
//   debugPrint('Body: ${message.notification?.body}');
//   debugPrint('Payload: ${message.data}');
// }

// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initNotifications() async {
//     if (kIsWeb) {
//       debugPrint('웹 환경에서는 Firebase Messaging을 초기화하지 않습니다.');
//       return;
//     }

//     await _firebaseMessaging.requestPermission();

//     final fCMToken = await _firebaseMessaging.getToken();
//     debugPrint('Token: $fCMToken'); // 실제 앱 운영 시 DB에 저장

//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       _handleMessage(message);
//     });

//     final initialMessage = await _firebaseMessaging.getInitialMessage();
//     if (initialMessage != null) {
//       _handleMessage(initialMessage);
//     }
//   }

//   void _handleMessage(RemoteMessage message) {
//     Future.delayed(Duration.zero, () {
//       navigatorKey.currentState?.push(
//         MaterialPageRoute(builder: (_) => ScreenMainTabs()),
//       );
//     });
//   }
// }
