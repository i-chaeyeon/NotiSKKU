import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/services/preferences_starred.dart';

class StarredState {
  final List<Notice> starredNotices;

  const StarredState({this.starredNotices = const []});

  StarredState copyWith({List<Notice>? starredNotices}) {
    return StarredState(starredNotices: starredNotices ?? this.starredNotices);
  }
}

class StarredNotifier extends StateNotifier<StarredState> {
  StarredNotifier() : super(const StarredState()) {
    _loadStarredNotices();
  }

  Future<void> _loadStarredNotices() async {
    List<Notice>? starredNotices = await NoticePreferences.load();
    starredNotices = starredNotices.reversed.toList();
    state = state.copyWith(starredNotices: starredNotices);
  }

  void toggleNotice(Notice notice) async {
    final currentStarredList = List<Notice>.from(state.starredNotices);
    if (currentStarredList.contains(notice)) {
      currentStarredList.remove(notice);
    } else {
      currentStarredList.add(notice);
    }
    state = state.copyWith(starredNotices: currentStarredList);
    NoticePreferences.save(currentStarredList);
  }
}

final starredProvider = StateNotifierProvider<StarredNotifier, StarredState>((
  ref,
) {
  return StarredNotifier();
});
