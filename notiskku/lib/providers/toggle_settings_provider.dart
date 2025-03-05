import 'package:flutter_riverpod/flutter_riverpod.dart';

// 학과/키워드 탭 인덱스 관리 (0 = 학과, 1 = 키워드)
final toggleIndexProvider = StateProvider<int>((ref) => 0);
