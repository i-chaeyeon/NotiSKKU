import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/firebase/topic_subscription.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/screen/screen_intro_ready.dart';
import 'package:notiskku/services/preferences_app.dart';
import 'package:notiskku/screen/screen_main_tabs.dart';

class ScreenIntroLoading extends ConsumerStatefulWidget {
  const ScreenIntroLoading({super.key, this.isFromOthers = false});
  final bool isFromOthers;

  @override
  ConsumerState<ScreenIntroLoading> createState() => _ScreenIntroLoadingState();
}

class _ScreenIntroLoadingState extends ConsumerState<ScreenIntroLoading> {
  @override
  void initState() {
    super.initState();
    // 빌드가 시작된 뒤에 초기화 로직 실행 (스낵바/네비게이션 안전)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSubscriptions();
    });
  }

  Future<void> _initSubscriptions() async {
    final majors = ref.read(userProvider).selectedMajors;
    final keywords = ref.read(userProvider).selectedKeywords;

    try {
      await TopicSubscription.subscribeToAll(
        keywords: keywords,
        majors: majors,
      );

      await AppPreferences.setFirstLaunch();

      if (!mounted) return;

      _showSnack('알림 구독이 완료되었습니다.');

      final next =
          widget.isFromOthers
              ? const ScreenMainTabs()
              : const ScreenIntroReady();

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => next));
    } catch (e) {
      await AppPreferences.setFirstLaunch();

      if (!mounted) return;

      _showSnack('알림 구독에 실패했습니다: $e', isError: true);

      final next =
          widget.isFromOthers
              ? const ScreenMainTabs()
              : const ScreenIntroReady();

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => next));
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    // 이미 addPostFrameCallback으로 보장되지만, Scaffold 준비 전 호출 방지용
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/fourth_fix.png',
                height: 170.h,
                width: 170.h,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 23.h),
              Text(
                '로딩 중...',
                style: TextStyle(
                  color: const Color(0xFF0B5B42),
                  fontSize: 24.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
