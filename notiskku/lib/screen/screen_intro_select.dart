import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/widget/grid/grid_keywords.dart';
import 'package:notiskku/widget/toggle/toggle_settings.dart';
import 'package:notiskku/widget/list/list_major.dart';
import 'package:notiskku/providers/toggle_settings_provider.dart';
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/providers/keyword_provider.dart';
import 'package:notiskku/widget/button/wide_condition.dart'; 

class ScreenIntroSelect extends ConsumerWidget {
  const ScreenIntroSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggleIndex = ref.watch(toggleIndexProvider);
    final majorState = ref.watch(majorProvider);
    final keywordState = ref.watch(keywordProvider);

    // 버튼 활성화 조건: 학과 1개 이상 + 키워드 1개 이상 선택
    final isButtonEnabled = majorState.selectedMajors.isNotEmpty && keywordState.selectedKeywords.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 80.h),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                '관심 학과와 키워드를 선택해주세요😀\n(학과는 최대 2개까지 가능)',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.9),
                  fontSize: 14.sp,
                  fontFamily: 'GmarketSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),

          const ToggleSettings(),
          SizedBox(height: 10.h),

          Expanded(
            child: toggleIndex == 0
                ? const ListMajor()
                : const GridKeywords(),
          ),

          SizedBox(height: 30.h),

          // '설정완료' 버튼 추가
          WideCondition(
            text: '설정완료',
            isEnabled: isButtonEnabled,
            onPressed: isButtonEnabled
                ? () {
                    // 여기에 다음 화면 이동 로직 추가 가능
                    Navigator.pushNamed(context, '/setAlarmScreen'); // 예시로 경로 이동 추가
                  }
                : null,
          ),
          SizedBox(height: 30.h), // 하단 여백 추가
        ],
      ),
    );
  }
}
