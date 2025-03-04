import 'package:flutter_riverpod/flutter_riverpod.dart';

// 상단 학교/단과대학/학과 탭 상태
final noticeCategoryProvider = StateProvider<int>((ref) => 0);

// 하위 카테고리 상태 (전체, 학사, 입학...)
final noticeSubCategoryProvider = StateProvider<int>((ref) => 0);
