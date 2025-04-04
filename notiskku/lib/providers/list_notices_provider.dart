import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/google/google_sheets_api.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/providers/major_provider.dart';

class NoticeState {
  final List<Notice> notices;

  const NoticeState({this.notices = const []});

  NoticeState copyWith({List<Notice>? notices}) {
    return NoticeState(notices: notices ?? this.notices);
  }
}

class NoticesNotifier extends StateNotifier<NoticeState> {
  NoticesNotifier({required this.fetchFunction, required this.categoryName})
    : super(const NoticeState()) {
    refreshNotices();
  }

  final Future<List<Notice>> Function({int startRow, int limit}) fetchFunction;
  final Categories categoryName;
  int currentRow = 1;
  bool isLoading = false;
  bool hasMore = true;

  Future<void> refreshNotices() async {
    currentRow = 1;
    hasMore = true;
    final allData = await fetchFunction(startRow: 1, limit: 10);
    final filtered = _filterByCategory(allData);
    state = state.copyWith(notices: filtered);
    currentRow += filtered.length;
  }

  Future<void> loadMoreNotices() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    try {
      final data = await fetchFunction(startRow: currentRow, limit: 10);
      if (data.isEmpty) {
        hasMore = false;
      } else {
        final filtered = _filterByCategory(data);
        state = state.copyWith(notices: [...state.notices, ...filtered]);
        currentRow += filtered.length;
      }
    } finally {
      isLoading = false;
    }
  }

  List<Notice> _filterByCategory(List<Notice> data) {
    if (categoryName == Categories.all) return data;
    return data.where((n) => n.category == "[$categoryName]").toList();
  }
}

final listNoticesProvider = StateNotifierProvider<NoticesNotifier, NoticeState>(
  (ref) {
    final majorState = ref.watch(majorProvider);
    final selectedMajors = majorState.selectedMajors;

    final noticeType = ref.watch(barNoticesProvider);

    final categoryName = ref.watch(barCategoriesProvider);

    Future<List<Notice>> fetchFunction({
      int startRow = 1,
      int limit = 10,
    }) async {
      if (noticeType == Notices.common) {
        return GoogleSheetsAPI.readCommonData(startRow: startRow, limit: limit);
      }

      final fetches = selectedMajors.map((major) {
        if (noticeType == Notices.dept) {
          return GoogleSheetsAPI.readDeptData(
            dept: major.department,
            startRow: startRow,
            limit: limit,
          );
        } else {
          return GoogleSheetsAPI.readMajorData(
            major: major.major,
            startRow: startRow,
            limit: limit,
          );
        }
      });

      final results = await Future.wait(fetches);
      return results.expand((list) => list).toList();
    }

    return NoticesNotifier(
      categoryName: categoryName,
      fetchFunction: fetchFunction,
    );
  },
);
