import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/firebase/topic_subscription.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/screen/screen_intro_ready.dart';
import 'package:notiskku/services/preferences_app.dart';

// 여기서 토큰도 날려야 함
// 만약에 학과, 키워드 설정 안했으면 주제 구독은 안하고, 토큰만 날림

class ScreenIntroLoading extends ConsumerStatefulWidget {
  const ScreenIntroLoading({super.key});

  @override
  ConsumerState<ScreenIntroLoading> createState() => _ScreenIntroLoadingState();
}

class _ScreenIntroLoadingState extends ConsumerState<ScreenIntroLoading> {
  @override
  void initState() {
    super.initState();
    _initSubscriptions();
  }

  Future<void> _initSubscriptions() async {
    final majors = ref.read(userProvider).selectedMajors;
    final keywords = ref.read(userProvider).selectedKeywords;

    try {
      await TopicSubscription.subscribeToAll(
        keywords: keywords,
        majors: majors,
      );

      // 구독 성공 후 바로 다음 화면으로 이동
      if (mounted) {
        await AppPreferences.setFirstLaunch();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ScreenIntroReady()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('알림 구독이 완료되었습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('알림 구독에 실패했습니다: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );

        // 개발/테스트용 !!! 일단 화면 넘겨....
        await AppPreferences.setFirstLaunch();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ScreenIntroReady()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      color: Color(0xFF0B5B42),
                      fontSize: 24.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
