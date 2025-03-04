import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/major_provider.dart';
// import 'package:notiskku/providers/alarm_major_provider.dart';

class AlarmMajorList extends ConsumerWidget {
  const AlarmMajorList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final majorState = ref.watch(majorProvider);
    final majorNotifier = ref.read(majorProvider.notifier);

    return Column(
      children: majorState.filteredMajors.map((major) {
        final isSelected = majorState.selectedMajors.contains(major);

        return GestureDetector(
          onTap: () => majorNotifier.toggleMajor(major),
          child: FractionallySizedBox(
            widthFactor: 0.85,
            child: Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xB20B5B42) : const Color(0x99D9D9D9),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: Text(
                  major,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isSelected ? Colors.white : const Color(0xFF979797),
                    fontWeight: FontWeight.bold,
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
