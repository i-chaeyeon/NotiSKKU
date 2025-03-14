import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/notice_functions/fetch_notice.dart';
import 'package:notiskku/providers/major_provider.dart'; // 과 선택 정보 가져옴
import 'package:notiskku/providers/bar_providers.dart'; // 학과|단과대학|학과, 전체|학사|입학|취업|... 선택 정보 가져옴

// 공지 데이터 제공을 위한 FutureProvider
final listNoticesProvider = FutureProvider<List<Notice>>((ref) async {
  final majorState = ref.watch(majorProvider);
  final categoryIndex = ref.watch(barCategoriesProvider); // 선택된 카테고리 인덱스 가져오기

  final selectedMajors = majorState.selectedMajors;
  final majorOrDepartment = selectedMajors.isNotEmpty ? selectedMajors[0] : '';

  return NoticeService().fetchNotices(
    _getCategoryUrl(categoryIndex, majorOrDepartment),
  );
});

// 카테고리별 URL 반환 함수 수정 (추후 수정 필요 !!)
String _getCategoryUrl(int index, String majorOrDepartment) {
  // 소프트웨어학과의 경우 특정 URL 반환
  if (majorOrDepartment == '소프트웨어학과') {
    if (index == 2) {  // selectedCategoryIndex → index 변경
      switch (index) {
        case 1: return 'https://cse.skku.edu/cse/notice.do?mode=list&srCategoryId1=1582';
        case 2: return 'https://cse.skku.edu/cse/notice.do?mode=list&srCategoryId1=1583';
        case 3: return 'https://cse.skku.edu/cse/notice.do?mode=list&srCategoryId1=1584';
        case 4: return 'https://cse.skku.edu/cse/notice.do?mode=list&srCategoryId1=1585';
        case 5: return 'https://cse.skku.edu/cse/notice.do?mode=list&srCategoryId1=1586';
        case 6: return 'https://cse.skku.edu/cse/notice.do?mode=list&srCategoryId1=1587';
        case 7: return 'https://cse.skku.edu/cse/notice.do?mode=list&srCategoryId1=1588';
        default: return 'https://cse.skku.edu/cse/notice.do?mode=list';
      }
    } else if (index == 1) { // selectedCategoryIndex → index 변경
      switch (index) {
        case 1: return 'https://sw.skku.edu/sw/notice.do?mode=list&srCategoryId1=1582';
        case 2: return 'https://sw.skku.edu/sw/notice.do?mode=list&srCategoryId1=1583';
        case 3: return 'https://sw.skku.edu/sw/notice.do?mode=list&srCategoryId1=1584';
        case 4: return 'https://sw.skku.edu/sw/notice.do?mode=list&srCategoryId1=1585';
        case 5: return 'https://sw.skku.edu/sw/notice.do?mode=list&srCategoryId1=1586';
        case 6: return 'https://sw.skku.edu/sw/notice.do?mode=list&srCategoryId1=1587';
        case 7: return 'https://sw.skku.edu/sw/notice.do?mode=list&srCategoryId1=1588';
        case 8: return 'https://sw.skku.edu/sw/notice.do?mode=list&srCategoryId1=1589';
        default: return 'https://sw.skku.edu/sw/notice.do';
      }
    }
  }

  // 일반 학과의 경우 (학교 선택 포함)
  if (index == 0 || index == 1 || index == 2) { // selectedCategoryIndex → index 변경
    switch (index) {
      case 1: return 'https://www.skku.edu/skku/campus/skk_comm/notice02.do';
      case 2: return 'https://www.skku.edu/skku/campus/skk_comm/notice03.do';
      case 3: return 'https://www.skku.edu/skku/campus/skk_comm/notice04.do';
      case 4: return 'https://www.skku.edu/skku/campus/skk_comm/notice05.do';
      case 5: return 'https://www.skku.edu/skku/campus/skk_comm/notice06.do';
      case 6: return 'https://www.skku.edu/skku/campus/skk_comm/notice07.do';
      case 7: return 'https://www.skku.edu/skku/campus/skk_comm/notice08.do';
      default: return 'https://www.skku.edu/skku/campus/skk_comm/notice01.do';
    }
  }

  // 🔹 기본 URL 반환
  return 'https://defaulturl.com';
}
