import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/toggle_settings_provider.dart';

class ToggleSettings extends ConsumerWidget {
  const ToggleSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggleIndex = ref.watch(toggleIndexProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(ref, 0, "학과", 0.4.sw),
        SizedBox(width: 12.w),
        _buildButton(ref, 1, "키워드", 0.4.sw),
      ],
    );
  }

  Widget _buildButton(WidgetRef ref, int index, String text, double buttonWidth) {
    final isSelected = ref.watch(toggleIndexProvider) == index;

    return GestureDetector(
      onTap: () {
        ref.read(toggleIndexProvider.notifier).state = index;
      },
      child: Container(
        width: buttonWidth,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF0B5B42) : const Color(0xFF979797),
              width: isSelected ? 2.5.h : 1.h,
            ),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w300,
              color: isSelected ? const Color(0xFF0B5B42) : const Color(0xFF979797),
            ),
          ),
        ),
      ),
    );
  }
}
