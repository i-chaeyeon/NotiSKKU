import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/keyword.dart';
import 'package:notiskku/services/preferences_keyword.dart';

class KeywordState {
  final List<Keyword> selectedKeywords;
  final bool isDoNotSelect;
  final bool isDoNotSelectAlarm;

  const KeywordState({
    this.selectedKeywords = const [],
    this.isDoNotSelect = false,
    this.isDoNotSelectAlarm = false,
  });

  KeywordState copyWith({
    List<Keyword>? selectedKeywords,
    bool? isDoNotSelect,
    bool? isDoNotSelectAlarm,
  }) {
    return KeywordState(
      selectedKeywords: selectedKeywords ?? this.selectedKeywords,
      isDoNotSelect: isDoNotSelect ?? this.isDoNotSelect,
      isDoNotSelectAlarm: isDoNotSelectAlarm ?? this.isDoNotSelectAlarm,
    );
  }
}

class KeywordNotifier extends StateNotifier<KeywordState> {
  KeywordNotifier() : super(const KeywordState()) {
    _loadSelectedKeywords();
  }
  // 저장된 selectedKeywords 불러오기
  Future<void> _loadSelectedKeywords() async {
    final selectedKeywords = await KeywordPreferences.load();

    state = state.copyWith(selectedKeywords: selectedKeywords);
  }

  // selectedKeywords 추가/제거 관리
  void toggleKeyword(Keyword keyword) {
    final currentKeywords = List<Keyword>.from(state.selectedKeywords);
    if (state.isDoNotSelect == true) {
      toggleDoNotSelect();
    }
    if (currentKeywords.contains(keyword)) {
      currentKeywords.remove(keyword);
    } else {
      currentKeywords.add(keyword);
    }

    state = state.copyWith(selectedKeywords: currentKeywords);
    KeywordPreferences.save(currentKeywords);
  }

  // alarmKeywords 추가/제거 관리
  void toggleAlarm(Keyword keyword) {
    final updatedKeywords =
        state.selectedKeywords.map((k) {
          if (k.keyword == keyword.keyword) {
            return k.copyWith(receiveNotification: !k.receiveNotification);
          }
          return k;
        }).toList();

    state = state.copyWith(selectedKeywords: updatedKeywords);
    KeywordPreferences.save(updatedKeywords);
  }

  // selectedKeywords '선택하지 않음' 토글 관리
  void toggleDoNotSelect() {
    state = state.copyWith(
      selectedKeywords: [],
      isDoNotSelect: !state.isDoNotSelect,
    );

    KeywordPreferences.save([]);
  }

  // alarmKeywords '선택하지 않음' 토글 관리
  // void toggleDoNotSelectAlarm() {
  //   if (state.isDoNotSelectAlarm) {
  //     state = state.copyWith(isDoNotSelectAlarm: false);
  //   } else {
  //     final updatedKeywords =
  //         state.selectedKeywords.map((k) {
  //           return k.copyWith(receiveNotification: false);
  //         }).toList();

  //     state = state.copyWith(
  //       selectedKeywords: updatedKeywords,
  //       isDoNotSelectAlarm: true,
  //     );

  //     KeywordPreferences.save(updatedKeywords);
  //   }
  // }
}

// Provider 등록, keyword 관련 정보 관리
final keywordProvider = StateNotifierProvider<KeywordNotifier, KeywordState>((
  ref,
) {
  return KeywordNotifier();
});
