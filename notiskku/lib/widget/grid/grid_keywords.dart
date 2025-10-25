import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/data/keyword_data.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class GridKeywords extends ConsumerWidget {
  const GridKeywords({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        SizedBox(height: 10.h),

        // '선택하지 않음' 버튼
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: _DoNotSelectButton(
            isSelected: userState.doNotSelectKeywords,
            onPressed: () => userNotifier.toggleDoNotSelectKeywords(),
          ),
        ),
        SizedBox(height: 25.h),

        // 키워드 선택 Grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 36.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3열
              childAspectRatio: 86.w / 37.h,
              crossAxisSpacing: 19.w, // 열 간 간격
              mainAxisSpacing: 23.h, // 행 간 간격
            ),
            itemCount: keywords.length,
            itemBuilder: (context, index) {
              final keyword = keywords[index].keyword;
              final matchedKeyword = keywords.firstWhere(
                (k) => k.keyword == keyword,
              );
              final isSelected = userState.selectedKeywords.contains(
                matchedKeyword,
              );

              final bgColor =
                  isSelected ? scheme.primary : scheme.outlineVariant;
              final fgColor =
                  isSelected
                      ? scheme.onPrimary
                      : scheme.onSurface.withOpacity(0.70); // 비선택 가독성

              return GestureDetector(
                onTap: () => userNotifier.toggleKeyword(matchedKeyword),
                child: Container(
                  width: 86.w,
                  height: 37.h,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        keyword,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineLarge?.copyWith(
                          fontSize: 18.sp,
                          color: fgColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// GridKeywords 안에만 쓰는 private 위젯
class _DoNotSelectButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onPressed;

  const _DoNotSelectButton({required this.isSelected, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // WideCondition과 동일한 원리: primary/onPrimary vs outlineVariant/onSurface
    final bgColor = isSelected ? scheme.primary : scheme.outlineVariant;
    final fgColor =
        isSelected ? scheme.onPrimary : scheme.onSurface.withOpacity(0.70);

    return SizedBox(
      width: 282.w,
      height: 36.h,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(bgColor),
          foregroundColor: WidgetStateProperty.all(fgColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          ),
          // WideCondition과의 일관성: 잔상 제거(필요시)
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return fgColor.withOpacity(0.08);
            }
            return null;
          }),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '선택하지 않음',
            style: textTheme.headlineLarge?.copyWith(
              fontSize: 18.sp,
              color: fgColor,
            ),
          ),
        ),
      ),
    );
  }
}
