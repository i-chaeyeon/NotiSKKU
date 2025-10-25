import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/widget/button/wide_condition.dart';
import 'package:notiskku/widget/list/list_major.dart';
import 'package:notiskku/screen/screen_intro_loading.dart'; // ✅ 추가

class ScreenMainMajorEdit extends ConsumerWidget {
  const ScreenMainMajorEdit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final isButtonEnabled = userState.selectedMajors.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          '학과 선택 편집',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                '관심 학과를 선택해주세요😀\n(학과는 최대 2개까지 가능)',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontFamily: 'GmarketSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          const Expanded(child: ListMajor()),
          SizedBox(height: 30.h),
          WideCondition(
            text: '설정 완료',
            isEnabled: isButtonEnabled,
            onPressed:
                isButtonEnabled
                    ? () async {
                      final user = ref.read(userProvider);

                      // 🔍 디버깅 로그
                      debugPrint('-----------------------------');
                      debugPrint(
                        '⚙️ [ScreenMainMajorEdit] 학과 편집 완료 → 로딩 화면으로 이동',
                      );
                      debugPrint(
                        '선택된 학과: ${user.selectedMajors.map((m) => m.major).join(", ")}',
                      );
                      debugPrint(
                        '알림 설정(major): '
                        '${user.selectedMajors.map((m) => "${m.major}=${m.receiveNotification}").join(", ")}',
                      );
                      debugPrint('-----------------------------');

                      // ✅ 로딩 화면으로 이동 (해당 화면에서 syncAll 수행)
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => const ScreenIntroLoading(
                                  isFromOthers: true, // 편집 경유 플래그 (옵션)
                                ),
                          ),
                        );
                      }
                    }
                    : null,
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
