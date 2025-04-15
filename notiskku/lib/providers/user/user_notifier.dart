import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/keyword.dart';
import 'package:notiskku/models/major.dart';
import 'package:notiskku/providers/user/user_state.dart';
import 'package:notiskku/services/preference_user.dart';

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState()) {
    _loadAll();
  }

  // Helper
  // 필요 시 각각 분리해서 추가 가능
  Future<void> _loadAll() async {
    final savedMajors = await UserPreferences.loadMajor();
    final savedKeywords = await UserPreferences.loadKeywords();
    final savedNotices = await UserPreferences.loadStarred();
    final savedSearchedText = await UserPreferences.loadRecentSearch();

    state = state.copyWith(
      selectedMajors: savedMajors,
      selectedKeywords: savedKeywords,
      starredNotices: savedNotices,
      recentSearchedText: savedSearchedText,
    );
  }

  // 전공 선택
  bool toggleMajor(Major major) {
    final currentMajors = List<Major>.from(state.selectedMajors);

    if (currentMajors.contains(major)) {
      currentMajors.remove(major);
    } else if (currentMajors.length < 2) {
      currentMajors.add(major);
    } else {
      return false;
    }

    state = state.copyWith(selectedMajors: currentMajors);
    UserPreferences.saveMajor(currentMajors);
    return true;
  }

  // 선택된 전공별 알림 여부 선택
  void toggleMajorAlarm(Major major) {
    final updatedMajors =
        state.selectedMajors.map((m) {
          if (m.major == major.major) {
            return m.copyWith(receiveNotification: !m.receiveNotification);
          }
          return m;
        }).toList();

    state = state.copyWith(selectedMajors: updatedMajors);
    UserPreferences.saveMajor(updatedMajors);
  }

  // 키워드 선택
  // "선택하지 않음" 버그 확인하지 않음
  void toggleKeyword(Keyword keyword) {
    final currentKeywords = List<Keyword>.from(state.selectedKeywords);
    if (state.doNotSelectKeywords == true) {
      toggleDoNotSelectKeywords();
    }
    if (currentKeywords.contains(keyword)) {
      currentKeywords.remove(keyword);
    } else {
      currentKeywords.add(keyword);
    }

    state = state.copyWith(selectedKeywords: currentKeywords);
    UserPreferences.saveKeywords(currentKeywords);
  }

  // "선택하지 않음" 토글 관리
  void toggleDoNotSelectKeywords() {
    state = state.copyWith(
      selectedKeywords: [],
      doNotSelectKeywords: !state.doNotSelectKeywords,
    );

    UserPreferences.saveKeywords([]);
  }

  // 선택된 키워드별 알림 여부 선택
  void toggleKeywordAlarm(Keyword keyword) {
    final updatedKeywords =
        state.selectedKeywords.map((k) {
          if (k.keyword == keyword.keyword) {
            return k.copyWith(receiveNotification: !k.receiveNotification);
          }
          return k;
        }).toList();

    state = state.copyWith(selectedKeywords: updatedKeywords);
    UserPreferences.saveKeywords(updatedKeywords);
  }

  // 별표 등록/제거
  void toggleStarredNotice(String hash) async {
    final currentStarredList = List<String>.from(state.starredNotices);
    if (currentStarredList.contains(hash)) {
      currentStarredList.remove(hash);
    } else {
      currentStarredList.add(hash);
    }
    state = state.copyWith(starredNotices: currentStarredList);
    UserPreferences.saveStarred(currentStarredList);
  }

  // 현재 검색어 업데이트
  void updateSearchText(String text) {
    state = state.copyWith(currentSearchText: text);
  }

  // 최근 검색어 추가 (중복 시 상단으로)
  void addRecentSearch(String text) {
    final currentRecentSearchedList = List<String>.from(
      state.recentSearchedText,
    );

    currentRecentSearchedList.remove(text);
    currentRecentSearchedList.add(text);

    state = state.copyWith(recentSearchedText: currentRecentSearchedList);
    UserPreferences.saveRecentSearch(currentRecentSearchedList);
  }

  // 최근 검색어 삭제
  void deleteRecentSearch(String text) {
    final currentRecentSearchedList = List<String>.from(
      state.recentSearchedText,
    );

    currentRecentSearchedList.remove(text);

    state = state.copyWith(recentSearchedText: currentRecentSearchedList);
    UserPreferences.saveRecentSearch(currentRecentSearchedList);
  }
}
