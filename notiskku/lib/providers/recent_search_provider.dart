import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/services/preferences_recent_search.dart';

class RecentSearchState {
  final List<String> searchedTexts;

  const RecentSearchState({this.searchedTexts = const []});

  RecentSearchState copyWith({List<String>? searchedTexts}) {
    return RecentSearchState(
      searchedTexts: searchedTexts ?? this.searchedTexts,
    );
  }
}

// 최근 검색어 상태 관리 Notifier
class RecentSearchNotifier extends StateNotifier<RecentSearchState> {
  RecentSearchNotifier() : super(const RecentSearchState()) {
    _loadSearchWords();
  }

  // 저장된 검색어 불러오기
  Future<void> _loadSearchWords() async {
    List<String>? searchedTexts =
        await RecentSearchPreferences.getSavedSearch();

    state = state.copyWith(searchedTexts: searchedTexts);
  }

  // 검색어 추가 (중복 시 최신순으로 이동)
  void searchWord(String word) {
    final currentWordList = List<String>.from(state.searchedTexts);

    currentWordList.remove(word);
    currentWordList.add(word);

    state = state.copyWith(searchedTexts: currentWordList);
    RecentSearchPreferences.saveSearch(currentWordList);
  }

  // 검색어 삭제
  void deleteWord(String word) {
    final currentWordList = List<String>.from(state.searchedTexts);

    currentWordList.remove(word);

    state = state.copyWith(searchedTexts: currentWordList);
    RecentSearchPreferences.saveSearch(currentWordList);
  }
}

// 최근 검색어 Provider
final recentSearchProvider =
    StateNotifierProvider<RecentSearchNotifier, RecentSearchState>((ref) {
      return RecentSearchNotifier();
    });
