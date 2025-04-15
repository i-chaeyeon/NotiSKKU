import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/user/user_notifier.dart';
import 'package:notiskku/providers/user/user_state.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
