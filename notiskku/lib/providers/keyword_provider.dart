import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/services/preference_services.dart';

// Provider 등록, keyword 관련 정보 관리 
final keywordProvider = StateNotifierProvider<KeywordNotifier, KeywordState>((
  ref,
) {
  return KeywordNotifier();
});

// State 정의
class KeywordState {
  final List<String> selectedKeywords; // 선택 키워드 string list로 저장
  final List<String> alarmKeywords; // 알림 키워드 string list로 저장
  final bool isDoNotSelect; // '선택하지 않음' 여부 (아무 키워드도 표시하지 않음)
  final bool isDoNotSelectAlarm; // 알림 '선택하지 않음' 여부 (아무 키워드도 알림 가지 않음음)

  const KeywordState({
    this.selectedKeywords = const [],
    this.alarmKeywords = const [],
    this.isDoNotSelect = false,
    this.isDoNotSelectAlarm = false,
  });

  KeywordState copyWith({
    List<String>? selectedKeywords,
    List<String>? alarmKeywords,
    bool? isDoNotSelect,
    bool? isDoNotSelectAlarm,
  }) {
    return KeywordState(
      selectedKeywords: selectedKeywords ?? this.selectedKeywords,
      alarmKeywords: alarmKeywords ?? this.alarmKeywords,
      isDoNotSelect: isDoNotSelect ?? this.isDoNotSelect,
      isDoNotSelectAlarm: isDoNotSelectAlarm ?? this.isDoNotSelectAlarm,
    );
  }
}

// StateNotifier 정의
class KeywordNotifier extends StateNotifier<KeywordState> {
  KeywordNotifier() : super(const KeywordState()) {
    _loadSelectedKeywords();
    _loadAlarmKeywords();
  }
  // 저장된 selectedKeywords 불러오기 
  Future<void> _loadSelectedKeywords() async {
    final savedKeywords = await getSelectedKeywords() ?? [];
    final isDoNotSelect = savedKeywords.contains('없음'); 

    state = state.copyWith(
      selectedKeywords: savedKeywords,
      isDoNotSelect: isDoNotSelect,
    );
  }

  // 저장된 alarmKeywords 불러오기 
  Future<void> _loadAlarmKeywords() async {
    final savedKeywords = await getAlarmKeywords() ?? [];
    final isDoNotSelect = savedKeywords.contains('없음');

    state = state.copyWith(
      alarmKeywords: savedKeywords,
      isDoNotSelectAlarm: isDoNotSelect,
    );
  }

  // selectedKeywords 추가/제거 관리 
  void toggleKeyword(String keyword) {
    final currentKeywords = List<String>.from(state.selectedKeywords);

    if (currentKeywords.contains(keyword)) {
      currentKeywords.remove(keyword);
    } else {
      currentKeywords.add(keyword);
    }

    state = state.copyWith(
      selectedKeywords: currentKeywords,
      isDoNotSelect: false, // 키워드 선택 시 '선택하지 않음' 해제
    );

    _saveSelectedKeywords();
  }

  // alarmKeywords 추가/제거 관리 
  void toggleAlarmKeyword(String keyword) {
    final currentKeywords = List<String>.from(state.alarmKeywords);

    if (currentKeywords.contains(keyword)) {
      currentKeywords.remove(keyword);
    } else {
      currentKeywords.add(keyword);
    }

    state = state.copyWith(
      alarmKeywords: currentKeywords,
      isDoNotSelectAlarm: false, // 알림 키워드 선택 시 '선택하지 않음' 해제
    );

    _saveAlarmKeywords();
  }

  // selectedKeywords '선택하지 않음' 토글 관리
  void toggleDoNotSelect() {
    if (state.isDoNotSelect) {
      state = state.copyWith(selectedKeywords: [], isDoNotSelect: false);
    } else {
      state = state.copyWith(selectedKeywords: ['없음'], isDoNotSelect: true);
    }

    _saveSelectedKeywords();
  }

  // alarmKeywords '선택하지 않음' 토글 관리 
  void toggleDoNotSelectAlarm() {
    if (state.isDoNotSelectAlarm) {
      state = state.copyWith(alarmKeywords: [], isDoNotSelectAlarm: false);
    } else {
      state = state.copyWith(alarmKeywords: ['없음'], isDoNotSelectAlarm: true);
    }

    _saveAlarmKeywords();
  }

  // 로컬 저장소에 selectedKeywords 저장
  Future<void> _saveSelectedKeywords() async {
    await saveSelectedKeywords(state.selectedKeywords);
  }

  // 로컬 저장소에 alarmKeywords 저장 
  Future<void> _saveAlarmKeywords() async {
    await saveAlarmKeywords(state.alarmKeywords);
  }
}
