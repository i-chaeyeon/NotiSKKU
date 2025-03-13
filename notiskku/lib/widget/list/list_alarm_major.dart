import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/major_provider.dart';


class ListAlarmMajor extends ConsumerWidget {
  const ListAlarmMajor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final majorState = ref.watch(majorProvider);
    final majorNotifier = ref.read(majorProvider.notifier);

    // 저장된 관심 전공만 필터링 (selectedMajors)
    final filteredMajors = majorState.majors.where((major) {
      return majorState.selectedMajors.contains(major);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: filteredMajors.map((major) {
        final isSelected = majorState.alarmMajors.contains(major);

        return GestureDetector(
          onTap: () => majorNotifier.toggleAlarmMajor(major),
          child: FractionallySizedBox(
            widthFactor: 0.85, // 버튼 너비 동일 유지
            child: Container(
              width: 294.w,
              height: 36.h,
              margin: EdgeInsets.only(bottom: 13.h),
              padding: EdgeInsets.symmetric(vertical: 7.h,),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xB20B5B42) : const Color(0x99D9D9D9),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: Text(
                  major,
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF979797),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
