import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WideGreen extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const WideGreen({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    final Color bg = scheme.primary;
    final Color fg = scheme.onPrimary; // 흰색 텍스트

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 40.h, minWidth: 301.w),
      child: SizedBox(
        width: 301.w,
        height: 40.h,
        child: TextButton(
          onPressed: onPressed, // null이면 클릭만 비활성화, 색은 그대로 유지
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(bg),
            foregroundColor: WidgetStateProperty.all(fg),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
            ),
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            minimumSize: WidgetStateProperty.all(Size(301.w, 40.h)),
            // 필요 시 포인터만 금지 커서로
            mouseCursor: WidgetStateProperty.resolveWith((states) {
              return (onPressed == null)
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click;
            }),
          ),
          child: Center(
            child: Text(
              text,
              style: textTheme.headlineMedium, // 색은 style에서 고정해두었음
            ),
          ),
        ),
      ),
    );
  }
}
