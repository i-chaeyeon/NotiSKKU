import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/notice_functions/fetch_notice.dart';
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/providers/notice_category_provider.dart';

// ✅ 공지사항 데이터 제공 프로바이더
final noticeListProvider = FutureProvider<List<Notice>>((ref) async {
  final majorState = ref.watch(majorProvider);
  final categoryIndex = ref.watch(noticeSubCategoryProvider);
  final topTabIndex = ref.watch(noticeCategoryProvider);

  final majorOrDepartment = majorState.selectedMajors.isNotEmpty
      ? majorState.selectedMajors[0]
      : '';

  return NoticeService().fetchNotices(
    getCategoryUrl(topTabIndex, categoryIndex, majorOrDepartment),
  );
});

// ✅ 카테고리 URL 생성 로직
String getCategoryUrl(int topTabIndex, int subCategoryIndex, String majorOrDepartment) {
  if (majorOrDepartment == '소프트웨어학과') {
    if (topTabIndex == 2) {
      return _getDepartmentNoticeUrl(subCategoryIndex);
    } else if (topTabIndex == 1) {
      return _getCollegeNoticeUrl(subCategoryIndex);
    }
  }
  return _getSchoolNoticeUrl(subCategoryIndex);
}

// 각 카테고리별 URL 매핑 예시 (필요에 맞게 커스텀)
String _getDepartmentNoticeUrl(int index) {
  return [
    'https://cse.skku.edu/cse/notice.do?mode=list',
    'https://cse.skku.edu/cse/notice.do?mode=list&srCategoryId1=1582',
    // 나머지 추가 가능
  ][index];
}

String _getCollegeNoticeUrl(int index) {
  return [
    'https://sw.skku.edu/sw/notice.do?mode=list',
    'https://sw.skku.edu/sw/notice.do?mode=list&srCategoryId1=1582',
    // 나머지 추가 가능
  ][index];
}

String _getSchoolNoticeUrl(int index) {
  return [
    'https://www.skku.edu/skku/campus/skk_comm/notice01.do',
    'https://www.skku.edu/skku/campus/skk_comm/notice02.do',
    // 나머지 추가 가능
  ][index];
}
