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

    final selectedKeywords = keywordState.selectedKeywords;

    if (selectedKeywords.isEmpty) {
      return const Center(child: Text('선택된 키워드가 없습니다.'));
    }

    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 86.w / 37.h,
          crossAxisSpacing: 19.w,
          mainAxisSpacing: 23.h,
        ),
        itemCount: selectedKeywords.length,
        itemBuilder: (context, index) {
          final keyword = selectedKeywords[index];
          final isSelectedForAlarm = keyword.receiveNotification;

          return GestureDetector(
            onTap: () => keywordNotifier.toggleAlarm(keyword),
            child: Container(
              width: 86.w,
              height: 37.h,
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color:
                    isSelectedForAlarm
                        ? const Color(0xB20B5B42)
                        : const Color(0x99D9D9D9),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown, // 글자가 너무 크면 자동으로 축소
                  child: Text(
                    keyword.keyword,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19.sp,
                      color:
                          isSelectedForAlarm
                              ? Colors.white
                              : const Color(0xFF979797),
                      fontWeight: FontWeight.w700,
                    ),
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
