import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/firebase/topic_subscription.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/screen/screen_intro_ready.dart';
import 'package:notiskku/services/preferences_app.dart';

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
