import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/services/preference_services.dart';

// 최근 검색어 Provider
final recentSearchProvider = 
    StateNotifierProvider<recentSearchNotifier, List<String>>((ref) {
  return recentSearchNotifier();
});

// 최근 검색어 상태 관리 Notifier
class recentSearchNotifier extends StateNotifier<List<String>> {
  recentSearchNotifier() : super([]) {
    _loadSearchWords();
  }

  // 저장된 검색어 불러오기
  Future<void> _loadSearchWords() async {
    List<String>? savedSearch = await getSavedSearch();
    if (savedSearch != null) {
      state = List<String>.from(savedSearch);
    }
  }
  
  // 검색어 추가 (중복 시 최신순으로 이동)
  void searchWord(String word) {
    if (state.contains(word)) {
      state = [
        ...state.where((w) => w != word), // 기존 목록에서 제거
        word // 최신 검색어로 추가
      ];
    } else {
      state = [...state, word];
    }
    saveSearch(state); // 저장
  }

  // 검색어 삭제
  void deleteWord(String word) {
    state = state.where((w) => w != word).toList();
    saveSearch(state); // 저장
  }
}
