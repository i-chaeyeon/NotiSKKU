import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/keyword_provider.dart';

class GridAlarmKeyword extends ConsumerWidget {
  const GridAlarmKeyword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keywordState = ref.watch(keywordProvider);
    final keywordNotifier = ref.read(keywordProvider.notifier);

    final selectedKeywords = keywordState.selectedKeywords; // 선택된 키워드
    final selectedAlarmKeywords = keywordState.alarmKeywords; // 알람 설정된 키워드

    // 반응형 버튼 크기 계산
    final buttonWidth = (1.sw - 80.w) / 3;
    final buttonHeight = buttonWidth * (37 / 86);

    if (selectedKeywords.isEmpty) {
      return const Center(child: Text('선택된 키워드가 없습니다.'));
    }

    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: buttonWidth / buttonHeight,
          crossAxisSpacing: 19.w,
          mainAxisSpacing: 30.h,
        ),
        itemCount: selectedKeywords.length,
        itemBuilder: (context, index) {
          final keyword = selectedKeywords[index];
          final isSelectedForAlarm = selectedAlarmKeywords.contains(keyword);

          return GestureDetector(
            onTap: () => keywordNotifier.toggleAlarmKeyword(keyword),
            child: Container(
              width: buttonWidth,
              height: buttonHeight,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: isSelectedForAlarm
                    ? const Color(0xB20B5B42) // 알람 설정됨
                    : const Color(0x99D9D9D9), // 알람 설정 안됨
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: Text(
                  keyword,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isSelectedForAlarm ? Colors.white : const Color(0xFF979797),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
