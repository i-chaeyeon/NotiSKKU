import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/bar_providers.dart';

class BarSettings extends ConsumerWidget {
  const BarSettings.barSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(ref, Settings.major, "학과", 130.w, context),
        SizedBox(width: 12.w),
        _buildButton(ref, Settings.keyword, "키워드", 130.w, context),
      ],
    );
  }

  Widget _buildButton(
    WidgetRef ref,
    Settings settings,
    String text,
    double buttonWidth,
    BuildContext context,
  ) {
    final isSelected = ref.watch(settingsProvider) == settings;

    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final underlineIdle = theme.disabledColor;
    final baseTextColor = theme.disabledColor;

    // 선택/비선택 색상 결정
    final underlineColor = isSelected ? primary : underlineIdle;
    final textColor = isSelected ? primary : baseTextColor;

    return GestureDetector(
      onTap: () => ref.read(settingsProvider.notifier).state = settings,
      child: Container(
        width: buttonWidth,
        padding: EdgeInsets.symmetric(vertical: 6.5.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: underlineColor,
              width: isSelected ? 2.h : 1.h,
            ),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontSize: 20.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w300,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
