import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WideGrey extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const WideGrey({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 301.w,
      height: 40.h,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return scheme.outlineVariant; // 비활성화 시 회색 계열
            }
            return scheme.outlineVariant; // 활성화 시 밝은 회색 배경
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return scheme.onSurface.withOpacity(0.38); // 비활성화 텍스트
            }
            return scheme.onPrimary; // 흰색 텍스트
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
          ),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: textTheme.headlineLarge?.copyWith(fontSize: 18.sp),
            ),
          ),
        ),
      ),
    );
  }
}
