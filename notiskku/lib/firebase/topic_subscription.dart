// lib/firebase/topic_subscription.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notiskku/models/keyword.dart';
import 'package:notiskku/models/major.dart';

class TopicSubscription {
  // ===== Helpers =====

  // Firebase topic은 안전한 문자만 사용 권장. (영문/숫자/언더스코어/하이픈)
  static String _sanitize(String raw) {
    var s = raw.trim();
    s = s.replaceAll(RegExp(r'\s+'), '-'); // 공백류 → '-'
    s = s.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), ''); // 허용 외 문자 제거
    return s.toLowerCase(); // 소문자 통일
  }

  static String _majorTopic(Major m) {
    // id가 존재하면 id, 없으면 이름 사용
    final key = m.id.isNotEmpty ? m.id : m.major;
    return _sanitize('major_$key');
  }

  static String _keywordTopic(Keyword k) {
    final key = k.id.isNotEmpty ? k.id : k.keyword;
    return _sanitize('keyword_$key');
  }

  // ===== Public APIs =====

  /// 현재 켜진( receiveNotification == true ) 항목만 구독
  static Future<void> subscribeToAll({
    required List<Keyword> keywords,
    required List<Major> majors,
  }) async {
    final fcm = FirebaseMessaging.instance;

    final majorTopics =
        majors
            .where((m) => m.receiveNotification == true)
            .map(_majorTopic)
            .toSet();

    final keywordTopics =
        keywords
            .where((k) => k.receiveNotification == true)
            .map(_keywordTopic)
            .toSet();

    await Future.wait([
      ...majorTopics.map(fcm.subscribeToTopic),
      ...keywordTopics.map(fcm.subscribeToTopic),
    ]);
  }

  /// 전달된 리스트에 포함된 모든 토픽을 해지 (ON/OFF 무관)
  static Future<void> unsubscribeFromAll({
    required List<Keyword> keywords,
    required List<Major> majors,
  }) async {
    final fcm = FirebaseMessaging.instance;

    final majorTopics = majors.map(_majorTopic).toSet();
    final keywordTopics = keywords.map(_keywordTopic).toSet();

    await Future.wait([
      ...majorTopics.map(fcm.unsubscribeFromTopic),
      ...keywordTopics.map(fcm.unsubscribeFromTopic),
    ]);
  }

  /// ✅ 권장: 단일 호출로 "해지 → ON만 재구독" 동기화
  /// - majors/keywords: 현재 상태의 전체 선택 리스트
  /// - 내부 규칙: receiveNotification == true 인 항목만 재구독
  static Future<void> syncAll({
    required List<Major> majors,
    required List<Keyword> keywords,
  }) async {
    final fcm = FirebaseMessaging.instance;

    // 1️⃣ 모든 토픽 해지
    final allMajorTopics = majors.map(_majorTopic).toSet();
    final allKeywordTopics = keywords.map(_keywordTopic).toSet();

    await Future.wait([
      ...allMajorTopics.map(fcm.unsubscribeFromTopic),
      ...allKeywordTopics.map(fcm.unsubscribeFromTopic),
    ]);

    // 2️⃣ ON인 항목만 재구독
    final enabledMajorTopics =
        majors
            .where((m) => m.receiveNotification == true)
            .map(_majorTopic)
            .toSet();

    final enabledKeywordTopics =
        keywords
            .where((k) => k.receiveNotification == true)
            .map(_keywordTopic)
            .toSet();

    if (enabledMajorTopics.isEmpty && enabledKeywordTopics.isEmpty) {
      return; // 모두 OFF면 재구독 생략
    }

    await Future.wait([
      ...enabledMajorTopics.map(fcm.subscribeToTopic),
      ...enabledKeywordTopics.map(fcm.subscribeToTopic),
    ]);
  }
}
