import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notiskku/models/keyword.dart';
import 'package:notiskku/models/major.dart';

class TopicSubscription {
  // 사용자가 선택한 전공 & 키워드 데이터를 받아와 주제 구독
  static Future<void> subscribeToAll({
    required List<Keyword> keywords,
    required List<Major> majors,
  }) async {
    // 전공 주제 구독 (전공, 단과대 각각에 대해 주제 구독)
    for (final m in majors) {
      if (m.receiveNotification) {
        await FirebaseMessaging.instance.subscribeToTopic('major-${m.major}');
        await FirebaseMessaging.instance.subscribeToTopic(
          'department-${m.department}',
        );
      }
    }

    // 키워드 주제 구독 'keyword-"선택한 키워드"' (예: "keyword-기숙사"와 같은 제목의 주제 구독)
    for (final k in keywords) {
      if (k.receiveNotification) {
        await FirebaseMessaging.instance.subscribeToTopic(
          'keyword-${k.keyword}',
        );
      }
    }
  }

  // 주제 구독 전체 해지 함수
  static Future<void> unsubscribeFromAll({
    required List<Keyword> keywords,
    required List<Major> majors,
  }) async {
    for (final m in majors) {
      await FirebaseMessaging.instance.unsubscribeFromTopic('major-${m.major}');
      await FirebaseMessaging.instance.unsubscribeFromTopic(
        'department-${m.department}',
      );
    }
    for (final k in keywords) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(
        'keyword-${k.keyword}',
      );
    }
  }
}
