// lib/screen/screen_intro_loading.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:notiskku/firebase/topic_subscription.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/screen/screen_intro_ready.dart';
import 'package:notiskku/screen/screen_main_tabs.dart';
import 'package:notiskku/services/preferences_app.dart';

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
    // 스낵바/네비게이션 안전 위해 첫 프레임 이후 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSubscriptions();
    });
  }

  Future<void> _initSubscriptions() async {
    final user = ref.read(userProvider);

    // 디버그용: 현재 선택 및 ON 항목 로그
    final enabledMajors =
        user.selectedMajors
            .where((m) => m.receiveNotification == true)
            .toList();
    final enabledKeywords =
        user.selectedKeywords
            .where((k) => k.receiveNotification == true)
            .toList();

    debugPrint('✅ [ScreenIntroLoading] isFromOthers: ${widget.isFromOthers}');
    debugPrint(
      '✅ [ScreenIntroLoading] majors (all): '
      '${user.selectedMajors.map((m) => m.major).join(", ")}',
    );
    debugPrint(
      '✅ [ScreenIntroLoading] majors (ON): '
      '${enabledMajors.map((m) => m.major).join(", ")}',
    );
    debugPrint(
      '✅ [ScreenIntroLoading] keywords (all): '
      '${user.selectedKeywords.map((k) => k.keyword).join(", ")}',
    );
    debugPrint(
      '✅ [ScreenIntroLoading] keywords (ON): '
      '${enabledKeywords.map((k) => k.keyword).join(", ")}',
    );

    try {
      // 🔁 해지 → ON만 재구독 (정합성 보장)
      await TopicSubscription.syncAll(
        majors: user.selectedMajors,
        keywords: user.selectedKeywords,
      );

      await AppPreferences.setFirstLaunch();
      if (!mounted) return;

      _showSnack('알림 구독이 완료되었습니다.');

      final next =
          widget.isFromOthers
              ? const ScreenMainTabs(showPostLoadNotice: true)
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
              ? const ScreenMainTabs(showPostLoadNotice: true)
              : const ScreenIntroReady();

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => next));
    }
  }

  void _showSnack(String message, {bool isError = false}) {
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
    const spinnerColor = Color(0xFF979797);

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
                '설정을 완료하는 중입니다!',
                style: TextStyle(
                  color: const Color(0xFF0B5B42),
                  fontSize: 20.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '잠시만 기다려 주세요...',
                    style: TextStyle(
                      color: spinnerColor,
                      fontSize: 18.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                    height: 16.w,
                    width: 16.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3.0,
                      valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
                      // iOS/Android 공통으로 자연스러운 기본 애니메이션
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
