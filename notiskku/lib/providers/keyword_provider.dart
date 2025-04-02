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
  void toggleDoNotSelectAlarm() {
    if (state.isDoNotSelectAlarm) {
      state = state.copyWith(isDoNotSelectAlarm: false);
    } else {
      final updatedKeywords =
          state.selectedKeywords.map((k) {
            return k.copyWith(receiveNotification: false);
          }).toList();

      state = state.copyWith(
        selectedKeywords: updatedKeywords,
        isDoNotSelectAlarm: true,
      );

      KeywordPreferences.save(updatedKeywords);
    }
  }
}

// Provider 등록, keyword 관련 정보 관리
final keywordProvider = StateNotifierProvider<KeywordNotifier, KeywordState>((
  ref,
) {
  return KeywordNotifier();
});

// State 정의
// class KeywordState {
//   final List<Keyword> keywords;

//   const KeywordState({this.keywords = const []});
//   final List<String> selectedKeywords; // 선택 키워드 string list로 저장
//   final List<String> alarmKeywords; // 알림 키워드 string list로 저장
//   final bool isDoNotSelect; // '선택하지 않음' 여부 (아무 키워드도 표시하지 않음)
//   final bool isDoNotSelectAlarm; // 알림 '선택하지 않음' 여부 (아무 키워드도 알림 가지 않음음)

//   const KeywordState({
//     this.selectedKeywords = const [],
//     this.alarmKeywords = const [],
//     this.isDoNotSelect = false,
//     this.isDoNotSelectAlarm = false,
//   });

//   KeywordState copyWith({
//     List<String>? selectedKeywords,
//     List<String>? alarmKeywords,
//     bool? isDoNotSelect,
//     bool? isDoNotSelectAlarm,
//   }) {
//     return KeywordState(
//       selectedKeywords: selectedKeywords ?? this.selectedKeywords,
//       alarmKeywords: alarmKeywords ?? this.alarmKeywords,
//       isDoNotSelect: isDoNotSelect ?? this.isDoNotSelect,
//       isDoNotSelectAlarm: isDoNotSelectAlarm ?? this.isDoNotSelectAlarm,
//     );
//   }
// }

// // StateNotifier 정의
// class KeywordNotifier extends StateNotifier<KeywordState> {
//   KeywordNotifier() : super(const KeywordState()) {
//     _loadSelectedKeywords();
//     _loadAlarmKeywords();
//   }
//   // 저장된 selectedKeywords 불러오기
//   Future<void> _loadSelectedKeywords() async {
//     final savedKeywords = await getSelectedKeywords() ?? [];
//     final isDoNotSelect = savedKeywords.contains('없음');

//     state = state.copyWith(
//       selectedKeywords: savedKeywords,
//       isDoNotSelect: isDoNotSelect,
//     );
//   }

//   // 저장된 alarmKeywords 불러오기
//   Future<void> _loadAlarmKeywords() async {
//     final savedKeywords = await getAlarmKeywords() ?? [];
//     final isDoNotSelect = savedKeywords.contains('없음');

//     state = state.copyWith(
//       alarmKeywords: savedKeywords,
//       isDoNotSelectAlarm: isDoNotSelect,
//     );
//   }

//   // selectedKeywords 추가/제거 관리
//   void toggleKeyword(String keyword) {
//     final currentKeywords = List<String>.from(state.selectedKeywords);

//     if (currentKeywords.contains(keyword)) {
//       currentKeywords.remove(keyword);
//     } else {
//       currentKeywords.add(keyword);
//     }

//     state = state.copyWith(
//       selectedKeywords: currentKeywords,
//       isDoNotSelect: false, // 키워드 선택 시 '선택하지 않음' 해제
//     );

//     _saveSelectedKeywords();
//   }

//   // alarmKeywords 추가/제거 관리
//   void toggleAlarmKeyword(String keyword) {
//     final currentKeywords = List<String>.from(state.alarmKeywords);

//     if (currentKeywords.contains(keyword)) {
//       currentKeywords.remove(keyword);
//     } else {
//       currentKeywords.add(keyword);
//     }

//     state = state.copyWith(
//       alarmKeywords: currentKeywords,
//       isDoNotSelectAlarm: false, // 알림 키워드 선택 시 '선택하지 않음' 해제
//     );

//     _saveAlarmKeywords();
//   }

//   // selectedKeywords '선택하지 않음' 토글 관리
//   void toggleDoNotSelect() {
//     if (state.isDoNotSelect) {
//       state = state.copyWith(selectedKeywords: [], isDoNotSelect: false);
//     } else {
//       state = state.copyWith(selectedKeywords: ['없음'], isDoNotSelect: true);
//     }

//     _saveSelectedKeywords();
//   }

//   // alarmKeywords '선택하지 않음' 토글 관리
//   void toggleDoNotSelectAlarm() {
//     if (state.isDoNotSelectAlarm) {
//       state = state.copyWith(alarmKeywords: [], isDoNotSelectAlarm: false);
//     } else {
//       state = state.copyWith(alarmKeywords: ['없음'], isDoNotSelectAlarm: true);
//     }

//     _saveAlarmKeywords();
//   }

//   // 로컬 저장소에 selectedKeywords 저장
//   Future<void> _saveSelectedKeywords() async {
//     await saveSelectedKeywords(state.selectedKeywords);
//   }

//   // 로컬 저장소에 alarmKeywords 저장
//   Future<void> _saveAlarmKeywords() async {
//     await saveAlarmKeywords(state.alarmKeywords);
//   }
// }
