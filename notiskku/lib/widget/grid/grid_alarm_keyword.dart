import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class GridAlarmKeyword extends ConsumerWidget {
  const GridAlarmKeyword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final selectedKeywords = userState.selectedKeywords;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child:
            selectedKeywords.isEmpty
                ? Center(
                  child: Text(
                    '선택된 키워드가 없습니다.',
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp,
                      color: scheme.onSurface.withOpacity(0.60),
                    ),
                  ),
                )
                : GridView.builder(
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

                    final bgColor =
                        isSelectedForAlarm
                            ? scheme.primary
                            : scheme.outlineVariant;
                    final fgColor =
                        isSelectedForAlarm
                            ? scheme.onPrimary
                            : scheme.onSurface.withOpacity(0.70);
                    return GestureDetector(
                      onTap: () => userNotifier.toggleKeywordAlarm(keyword),
                      child: Container(
                        width: 86.w,
                        height: 37.h,
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              keyword.keyword,
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
    );
  }
}
