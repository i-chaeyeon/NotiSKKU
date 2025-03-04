import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notiskku/data/major_data.dart';
import 'package:notiskku/services/preference_services.dart';

// 공통 State 정의
class MajorState {
  final List<String> selectedMajors;   // 일반 전공 선택
  final List<String> alarmMajors;      // 알림용 전공 선택
  final List<String> majors;           // 전체 전공 리스트
  final String searchText;

  const MajorState({
    this.selectedMajors = const [],
    this.alarmMajors = const [],
    this.majors = const [],
    this.searchText = '',
  });

  MajorState copyWith({
    List<String>? selectedMajors,
    List<String>? alarmMajors,
    List<String>? majors,
    String? searchText,
  }) {
    return MajorState(
      selectedMajors: selectedMajors ?? this.selectedMajors,
      alarmMajors: alarmMajors ?? this.alarmMajors,
      majors: majors ?? this.majors,
      searchText: searchText ?? this.searchText,
    );
  }
}

// Notifier 정의
class MajorNotifier extends StateNotifier<MajorState> {
  MajorNotifier() : super(MajorState(majors: major.map((e) => e.major).toList())) {
    _loadSelectedMajors();
    _loadAlarmMajors();
  }

  // 🔔 일반 전공 선택 관리
  void toggleMajor(String majorName) {
    final currentMajors = List<String>.from(state.selectedMajors);

    if (currentMajors.contains(majorName)) {
      currentMajors.remove(majorName);
    } else if (currentMajors.length < 2) {
      currentMajors.add(majorName);
    }

    state = state.copyWith(selectedMajors: currentMajors);
    _saveSelectedMajors();
  }

  // 🔔 알림용 전공 선택 관리
  void toggleAlarmMajor(String majorName) {
    final currentAlarms = List<String>.from(state.alarmMajors);

    if (currentAlarms.contains(majorName)) {
      currentAlarms.remove(majorName);
    } else {
      currentAlarms.add(majorName);
    }

    state = state.copyWith(alarmMajors: currentAlarms);
    _saveAlarmMajors();
  }

  // 🔎 검색어 업데이트
  void updateSearchText(String text) {
    state = state.copyWith(searchText: text);
  }

  // 📥 저장된 일반 전공 불러오기
  Future<void> _loadSelectedMajors() async {
    final savedMajors = await getSelectedMajors() ?? [];
    state = state.copyWith(selectedMajors: savedMajors);
  }

  // 📥 저장된 알림 전공 불러오기
  Future<void> _loadAlarmMajors() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAlarms = prefs.getStringList('alarmMajors') ?? [];
    state = state.copyWith(alarmMajors: savedAlarms);
  }

  // 💾 일반 전공 저장
  Future<void> _saveSelectedMajors() async {
    await saveSelectedMajors(state.selectedMajors);
  }

  // 💾 알림 전공 저장
  Future<void> _saveAlarmMajors() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('alarmMajors', state.alarmMajors);
  }
}

// Provider 등록
final majorProvider = StateNotifierProvider<MajorNotifier, MajorState>((ref) {
  return MajorNotifier();
});
