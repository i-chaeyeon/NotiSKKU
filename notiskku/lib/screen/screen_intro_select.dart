import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/widget/grid/grid_keywords.dart';
import 'package:notiskku/widget/toggle/toggle_settings.dart';
import 'package:notiskku/widget/list/list_major.dart';
import 'package:notiskku/providers/toggle_settings_provider.dart';
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/providers/keyword_provider.dart';

class ScreenIntroSelect extends ConsumerWidget {
  const ScreenIntroSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggleIndex = ref.watch(toggleIndexProvider);
    final majorState = ref.watch(majorProvider);
    final keywordState = ref.watch(keywordProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 80.h), // 반응형 여백

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

          // 토글 버튼 (학과/키워드 전환)
          const ToggleSettings(), // 여기도 currentIndex, onIndexChanged 제거
          SizedBox(height: 10.h),

          // 전공/키워드 선택 화면
          Expanded(
            child: toggleIndex == 0
                ? const ListMajor()   // 학과 선택 화면 (riverpod 연동)
                : const GridKeywords() // 키워드 선택 화면 (riverpod 연동)
          ),

          SizedBox(height: 30.h),

          // 완료 버튼 자리 (필요 시 나중에 추가 가능)
          // SetupCompleteButton(
          //   selectedMajor: majorState.selectedMajors,
          //   selectedKeyword: keywordState.selectedKeywords,
          // ),
        ],
      ),
    );
  }
}
