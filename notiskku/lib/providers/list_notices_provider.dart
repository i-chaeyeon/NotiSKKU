// 일단 학교 | 단과대 | 학과 부분만 구현 (bar notices)
// 전체 | 학사 | 채용/모집 등의 카테고리는 추후 구현 필요 (bar categories)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/google/google_sheets_api.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/widget/bar/bar_categories.dart';

final listNoticesProvider = StateNotifierProvider<
  NoticesNotifier,
  List<Notice>
>((ref) {
  final categoryIndex = ref.watch(barCategoriesProvider);
  final categoryName = BarCategories.categories[categoryIndex];

  final majorState = ref.watch(majorProvider);
  final selectedMajors = majorState.selectedMajors;
  final barIndex = ref.watch(barNoticesProvider);

  // 전공 선택 안했을 때 예외 처리 필요
  Future<List<Notice>> fetchFunc({int startRow = 1, int limit = 10}) {
    if (barIndex == 0) {
      // 공통
      return GoogleSheetsAPI.readCommonData(startRow: startRow, limit: limit);
    } else if (barIndex == 1) {
      // 단과대
      return GoogleSheetsAPI.readDeptData(
        dept: selectedMajors.first,
        startRow: startRow,
        limit: limit,
      );
    } else {
      // 학과
      return GoogleSheetsAPI.readMajorData(
        major: selectedMajors.first,
        startRow: startRow,
        limit: limit,
      );
    }
  }

  return NoticesNotifier(categoryName: categoryName, fetchFunction: fetchFunc);
});

class NoticesNotifier extends StateNotifier<List<Notice>> {
  NoticesNotifier({required this.fetchFunction, required this.categoryName})
    : super([]) {
    refreshNotices();
  }

  final Future<List<Notice>> Function({int startRow, int limit}) fetchFunction;
  final String categoryName;
  int currentRow = 1;
  bool isLoading = false;
  bool hasMore = true;

  Future<void> refreshNotices() async {
    currentRow = 1;
    hasMore = true;
    final allData = await fetchFunction(startRow: 1, limit: 10);
    final filtered = _filterByCategory(allData);
    state = filtered;
    currentRow += 10;
  }

  Future<void> loadMoreNotices() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    final data = await fetchFunction(startRow: currentRow, limit: 10);
    if (data.isEmpty) {
      hasMore = false;
    } else {
      final filtered = _filterByCategory(data);
      state = [...state, ...filtered];
      currentRow += 10;
    }
    isLoading = false;
  }

  List<Notice> _filterByCategory(List<Notice> data) {
    if (categoryName == '전체') return data;
    return data.where((n) => n.category == "[$categoryName]").toList();
  }
}
