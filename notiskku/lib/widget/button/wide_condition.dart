import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WideCondition extends StatelessWidget {
  final String text;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const WideCondition({
    super.key,
    required this.text,
    required this.isEnabled,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 301.w,
      height: 40.h,
      child: TextButton(
        onPressed: isEnabled ? onPressed : null,
        style: ButtonStyle(
          // 배경/전경색을 Material 상태로 분기
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return scheme.outlineVariant;
            }
            return scheme.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return scheme.onSurface.withOpacity(0.38);
            }
            return scheme.onPrimary; // 대비 좋은 흰색
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
              // 텍스트는 테마 타이포 사용
              style: textTheme.headlineLarge?.copyWith(fontSize: 18.sp),
            ),
          ),
        ),
      ),
    );
  }
}
