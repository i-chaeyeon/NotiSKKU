import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/data/major_data.dart';
import 'package:notiskku/services/preference_services.dart';

class MajorState {
  final List<String> selectedMajors;
  final List<String> majors;
  final String searchText;

  const MajorState({
    this.selectedMajors = const [],
    this.majors = const [],
    this.searchText = '',
  });

  MajorState copyWith({
    List<String>? selectedMajors,
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


class MajorNotifier extends StateNotifier<MajorState> {
  MajorNotifier() : super(MajorState(majors: major.map((e) => e.major).toList())) {
    _loadSelectedMajors();
  }

  void updateSearchText(String text) {
    state = state.copyWith(searchText: text);
  }

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

  Future<void> _loadSelectedMajors() async {
    final savedMajors = await getSelectedMajors() ?? [];
    state = state.copyWith(selectedMajors: savedMajors);
  }

  Future<void> _saveSelectedMajors() async {
    await saveSelectedMajors(state.selectedMajors);
  }
}

// Provider 등록
final majorProvider = StateNotifierProvider<MajorNotifier, MajorState>((ref) {
  return MajorNotifier();
});
