import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/notice_functions/fetch_notice.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/providers/keyword_provider.dart';
import 'package:notiskku/providers/major_provider.dart';

// 공지 데이터 제공을 위한 FutureProvider
final keyNoticeListProvider = FutureProvider<List<Notice>>((ref) async {
  final selectedCategoryIndex = ref.watch(barKeywordsProvider);
  final categories = ref.watch(keywordProvider);

  return NoticeService().fetchNotices(
    _getCategoryUrl(0),
  );
});

// ✅ 카테고리별 URL 반환 함수 수정
String _getCategoryUrl(int index) {
  return 'https://www.skku.edu/skku/campus/skk_comm/notice01.do';
}
