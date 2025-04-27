import 'package:notiskku/models/keyword.dart';
import 'package:notiskku/models/major.dart';

class UserState {
  final List<Major> selectedMajors;
  final List<Keyword> selectedKeywords;
  final bool doNotSelectKeywords;
  final List<String> starredNotices;
  final String currentSearchText;
  final List<String> recentSearchedText;

  const UserState({
    this.selectedMajors = const [],
    this.selectedKeywords = const [],
    this.doNotSelectKeywords = false,
    this.starredNotices = const [],
    this.currentSearchText = '',
    this.recentSearchedText = const [],
  });

  UserState copyWith({
    List<Major>? selectedMajors,
    List<Keyword>? selectedKeywords,
    bool? doNotSelectKeywords,
    List<String>? starredNotices,
    String? currentSearchText,
    List<String>? recentSearchedText,
  }) {
    return UserState(
      selectedMajors: selectedMajors ?? this.selectedMajors,
      selectedKeywords: selectedKeywords ?? this.selectedKeywords,
      doNotSelectKeywords: doNotSelectKeywords ?? this.doNotSelectKeywords,
      starredNotices: starredNotices ?? this.starredNotices,
      currentSearchText: currentSearchText ?? this.currentSearchText,
      recentSearchedText: recentSearchedText ?? this.recentSearchedText,
    );
  }
}
