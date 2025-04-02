// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:notiskku/models/notice.dart';
// import 'package:notiskku/notice_functions/fetch_notice.dart';
// import 'package:notiskku/providers/keyword_provider.dart';

// // 공지 데이터 제공을 위한 FutureProvider
// final ListKeyNoticesProvider = FutureProvider<List<Notice>>((ref) async {
//   final keywordState = ref.watch(keywordProvider);
//   final selectedKeywords = keywordState.selectedKeywords;

//   // 선택된 키워드가 없으면 기본 URL 사용
//   final url = selectedKeywords.isNotEmpty
//       ? _getCategoryUrl(selectedKeywords.first)
//       : 'https://www.skku.edu/skku/campus/skk_comm/notice01.do';

//   return NoticeService().fetchNotices(url);
// });

// // 키워드에 따른 URL 설정 (추후 구현 필요 !!)
// String _getCategoryUrl(String keyword) {
//   return 'https://www.skku.edu/skku/campus/skk_comm/notice01.do?keyword=$keyword';
// }
