import 'package:flutter_riverpod/flutter_riverpod.dart';

// BarSettings 관리
// 학과 | 키워드
// 학과/키워드 탭 인덱스 관리 (0 = 학과, 1 = 키워드)
final toggleIndexProvider = StateProvider<int>((ref) => 0);



// BarNotices 관리
// 학교 | 단과대학 | 학과
final barNoticesProvider = StateProvider<int>((ref) => 0);

// BarCategories 관리
// 전체, 장학, 취업, 학사, …
final barCategoriesProvider = StateProvider<int>((ref) => 0);


// BarKeywords 관리
// 공모전, 수강신청, 장학금, 계절학기 … 
final barKeywordsProvider = StateProvider<int>((ref) => 0);