import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/notice_functions/fetch_notice.dart';
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/providers/notice_category_provider.dart';

// 공지 리스트 Provider
final noticeListProvider = FutureProvider<List<Notice>>((ref) async {
  final selectedMajors = ref.watch(majorProvider).selectedMajors;
  final mainCategoryIndex = ref.watch(noticeMainCategoryProvider);
  final subCategoryIndex = ref.watch(noticeSubCategoryProvider);

  final majorOrDepartment = selectedMajors.isNotEmpty ? selectedMajors.first : '';
  final url = _getCategoryUrl(mainCategoryIndex, subCategoryIndex, majorOrDepartment);

  return NoticeService().fetchNotices(url);
});

/// ✅ URL 구성 로직 (위의 getCategoryUrl 리팩토링)
String _getCategoryUrl(int mainIndex, int subIndex, String majorOrDepartment) {
  if (majorOrDepartment == '소프트웨어학과') {
    if (mainIndex == 2) {
      // 학과 공지
      return _getSoftwareDeptUrl(subIndex);
    } else if (mainIndex == 1) {
      // 단과대학 공지
      return _getSoftwareCollegeUrl(subIndex);
    }
  }

  // 기본 학교 공지
  return _getSchoolUrl(subIndex);
}

/// 소프트웨어학과 - 학과 공지 URL
String _getSoftwareDeptUrl(int index) {
  const base = 'https://cse.skku.edu/cse/notice.do?mode=list';
  const params = [
    '',
    '&srCategoryId1=1582', '&srCategoryId1=1583', '&srCategoryId1=1584',
    '&srCategoryId1=1585', '&srCategoryId1=1586', '&srCategoryId1=1587',
    '&srCategoryId1=1588',
  ];
  return base + (params[index] ?? '');
}

/// 소프트웨어학과 - 단과대학 공지 URL
String _getSoftwareCollegeUrl(int index) {
  const base = 'https://sw.skku.edu/sw/notice.do?mode=list';
  const params = [
    '',
    '&srCategoryId1=1582', '&srCategoryId1=1583', '&srCategoryId1=1584',
    '&srCategoryId1=1585', '&srCategoryId1=1586', '&srCategoryId1=1587',
    '&srCategoryId1=1588', '&srCategoryId1=1589',
  ];
  return base + (params[index] ?? '');
}

/// 학교 전체 공지 URL
String _getSchoolUrl(int index) {
  const urls = [
    'https://www.skku.edu/skku/campus/skk_comm/notice01.do',
    'https://www.skku.edu/skku/campus/skk_comm/notice02.do',
    'https://www.skku.edu/skku/campus/skk_comm/notice03.do',
    'https://www.skku.edu/skku/campus/skk_comm/notice04.do',
    'https://www.skku.edu/skku/campus/skk_comm/notice05.do',
    'https://www.skku.edu/skku/campus/skk_comm/notice06.do',
    'https://www.skku.edu/skku/campus/skk_comm/notice07.do',
    'https://www.skku.edu/skku/campus/skk_comm/notice08.do',
  ];
  return urls[index];
}
