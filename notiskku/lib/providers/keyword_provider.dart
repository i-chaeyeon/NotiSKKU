import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/services/preference_services.dart';
import 'package:notiskku/data/keyword_data.dart';

// State 정의
class KeywordState {
  final List<String> selectedKeywords;
  final bool isDoNotSelect;

  const KeywordState({
    this.selectedKeywords = const [],
    this.isDoNotSelect = false,
  });

  // copyWith 추가
  KeywordState copyWith({
    List<String>? selectedKeywords,
    bool? isDoNotSelect,
  }) {
    return KeywordState(
      selectedKeywords: selectedKeywords ?? this.selectedKeywords,
      isDoNotSelect: isDoNotSelect ?? this.isDoNotSelect,
    );
  }
}

// StateNotifier 정의
class KeywordNotifier extends StateNotifier<KeywordState> {
  KeywordNotifier() : super(const KeywordState()) {
    _loadSelectedKeywords();
  }

  // 키워드 선택/해제 토글
  void toggleKeyword(String keyword) {
    final currentKeywords = List<String>.from(state.selectedKeywords);

    if (currentKeywords.contains(keyword)) {
      currentKeywords.remove(keyword);
    } else {
      currentKeywords.add(keyword);
    }

    state = state.copyWith(
      selectedKeywords: currentKeywords,
      isDoNotSelect: false, // 키워드 선택 시 '없음' 해제
    );

    _saveSelectedKeywords();
  }

  // "선택 안 함" 버튼 토글
  void toggleDoNotSelect() {
    if (state.isDoNotSelect) {
      state = state.copyWith(
        selectedKeywords: [],
        isDoNotSelect: false,
      );
    } else {
      state = state.copyWith(
        selectedKeywords: ['없음'],
        isDoNotSelect: true,
      );
    }

    _saveSelectedKeywords();
  }

  // 저장된 키워드 불러오기
  Future<void> _loadSelectedKeywords() async {
    final savedKeywords = await getSelectedKeywords() ?? [];
    final isDoNotSelect = savedKeywords.contains('없음');

    state = KeywordState(
      selectedKeywords: savedKeywords,
      isDoNotSelect: isDoNotSelect,
    );
  }

  // 선택된 키워드 저장
  Future<void> _saveSelectedKeywords() async {
    await saveSelectedKeywords(state.selectedKeywords);
  }
}

// Provider 등록
final keywordProvider = StateNotifierProvider<KeywordNotifier, KeywordState>((ref) {
  return KeywordNotifier();
});
