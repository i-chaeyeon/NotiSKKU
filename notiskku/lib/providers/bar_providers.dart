import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Settings { major, keyword }

enum Notices { common, dept, major }

enum Categories {
  all,
  academics,
  admission,
  employment,
  recruitment,
  scholarship,
  eventsAndSeminars,
  general,
}

enum Keywords {
  dormitory, // 기숙사
  tuition, // 등록금
  courseRegistration, // 수강신청
  contest, // 공모전
  scholarship, // 장학금
  returSschool, // 복학
  grade, // 성적
  leaveOfAbsence, // 휴학
  graduation, // 졸업
  volunteer, // 봉사
  abroad, // 해외
  internship, // 인턴
  seasonalClass, // 계절
}

// BarSettings 관리
// 학과 | 키워드
// 학과/키워드 탭 인덱스 관리 (0 = 학과, 1 = 키워드)
final settingsProvider = StateProvider<Settings>((ref) => Settings.major);

// BarNotices 관리
// 학교 | 단과대학 | 학과
final barNoticesProvider = StateProvider<Notices>((ref) => Notices.common);

// BarCategories 관리
// 전체, 장학, 취업, 학사, …
final barCategoriesProvider = StateProvider<Categories>(
  (ref) => Categories.all,
);

// BarKeywords 관리
// 공모전, 수강신청, 장학금, 계절학기 …
final barKeywordsProvider = StateProvider<Keywords>(
  (ref) => Keywords.dormitory,
);
