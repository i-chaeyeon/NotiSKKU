import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/major.dart';
import 'package:notiskku/services/preferences_major.dart';
import 'package:notiskku/data/major_data.dart';

class MajorState {
  final List<Major> selectedMajors;
  final List<String> majors; // 전체 전공 리스트
  final String searchText;

  const MajorState({
    this.selectedMajors = const [],
    this.majors = const [],
    this.searchText = '',
  });

  MajorState copyWith({
    List<Major>? selectedMajors,
    List<String>? majors,
    String? searchText,
  }) {
    return MajorState(
      selectedMajors: selectedMajors ?? this.selectedMajors,
      majors: majors ?? this.majors,
      searchText: searchText ?? this.searchText,
    );
  }
}

// Major 관련 정보 관리 Notifier
class MajorNotifier extends StateNotifier<MajorState> {
  MajorNotifier()
    : super(MajorState(majors: majors.map((e) => e.major).toList())) {
    _loadSelectedMajors();
  }

  // 저장된 selectedMajors 불러오기
  Future<void> _loadSelectedMajors() async {
    final savedMajors = await MajorPreferences.load();

    state = state.copyWith(selectedMajors: savedMajors);
  }

  // selectedMajors 추가/제거 관리
  bool toggleMajor(Major major) {
    final currentMajors = List<Major>.from(state.selectedMajors);

    if (currentMajors.contains(major)) {
      currentMajors.remove(major);
    } else if (currentMajors.length < 2) {
      currentMajors.add(major);
    } else {
      return false; // 2개 이상 선택 시 팝업 출력
    }

    state = state.copyWith(selectedMajors: currentMajors);
    MajorPreferences.save(currentMajors);
    return true;
  }

  void toggleAlarm(Major major) {
    final updatedMajors =
        state.selectedMajors.map((m) {
          if (m.major == major.major) {
            return m.copyWith(receiveNotification: !m.receiveNotification);
          }
          return m;
        }).toList();

    state = state.copyWith(selectedMajors: updatedMajors);
    MajorPreferences.save(updatedMajors);
  }

  // 검색어 업데이트
  void updateSearchText(String text) {
    state = state.copyWith(searchText: text);
  }
}

// Provider 등록, major 관련 정보 관리
final majorProvider = StateNotifierProvider<MajorNotifier, MajorState>((ref) {
  return MajorNotifier();
});

// Major 관련 정보를 통합해서 기록하기 위한 class 정의
// class MajorState {
//   final List<String> selectedMajors; // 선택 전공 string list로 저장
//   final List<String> alarmMajors; // 알림 전공 string list로 저장
//   final List<String> majors; // 전체 전공 리스트
//   final String searchText;

//   const MajorState({
//     // 기본 생성자, 기본값 설정
//     this.selectedMajors = const [],
//     this.alarmMajors = const [],
//     this.majors = const [],
//     this.searchText = '',
//   });

//   MajorState copyWith({
//     // 기존 상태를 안전하게 변경하는 메서드
//     List<String>? selectedMajors,
//     List<String>? alarmMajors,
//     List<String>? majors,
//     String? searchText,
//   }) {
//     return MajorState(
//       // null이 전달되면 기존 값을 유지 (?? this.필드명)
//       selectedMajors: selectedMajors ?? this.selectedMajors,
//       alarmMajors: alarmMajors ?? this.alarmMajors,
//       majors: majors ?? this.majors,
//       searchText: searchText ?? this.searchText,
//     );
//   }
// }

// // Major 관련 정보 관리 Notifier
// class MajorNotifier extends StateNotifier<MajorState> {
//   MajorNotifier()
//     : super(MajorState(majors: major.map((e) => e.major).toList())) {
//     // 저장소에 저장한 정보 불러오기
//     _loadSelectedMajors();
//     _loadAlarmMajors();
//   }

//   // 저장된 selectedMajors 불러오기
//   Future<void> _loadSelectedMajors() async {
//     final savedMajors = await getSelectedMajors() ?? [];
//     state = state.copyWith(selectedMajors: savedMajors);
//   }

//   // 저장된 alarmMajors 불러오기
//   Future<void> _loadAlarmMajors() async {
//     final savedAlarms = await getAlarmMajors() ?? [];
//     state = state.copyWith(alarmMajors: savedAlarms);
//   }

//   // selectedMajors 추가/제거 관리
//   void toggleSelectedMajor(String majorName) {
//     final currentMajors = List<String>.from(state.selectedMajors);
//     if (currentMajors.contains(majorName)) {
//       currentMajors.remove(majorName);
//     } else if (currentMajors.length < 2) {
//       currentMajors.add(majorName);
//     }
//     state = state.copyWith(selectedMajors: currentMajors);
//     _saveSelectedMajors();
//   }

//   // alalrmMajors 추가/제거 관리
//   void toggleAlarmMajor(String majorName) {
//     final currentAlarms = List<String>.from(state.alarmMajors);
//     if (currentAlarms.contains(majorName)) {
//       currentAlarms.remove(majorName);
//     } else {
//       currentAlarms.add(majorName);
//     }
//     state = state.copyWith(alarmMajors: currentAlarms);
//     _saveAlarmMajors();
//   }

//   // 검색어 업데이트
//   void updateSearchText(String text) {
//     state = state.copyWith(searchText: text);
//   }

//   // 로컬 저장소에 selectedMajors 저장
//   Future<void> _saveSelectedMajors() async {
//     await saveSelectedMajors(state.selectedMajors);
//   }

//   // 로컬 저장소에 alarmMajors 저장
//   Future<void> _saveAlarmMajors() async {
//     await saveAlarmMajors(state.alarmMajors);
//   }
// }
