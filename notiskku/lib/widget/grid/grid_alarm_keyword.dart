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

    final selectedKeywords = userState.selectedKeywords;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child:
            selectedKeywords.isEmpty
                ? Center(
                  child: Text(
                    '선택된 키워드가 없습니다.',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
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

                    return GestureDetector(
                      onTap: () => userNotifier.toggleKeywordAlarm(keyword),
                      child: Container(
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
                            fit: BoxFit.scaleDown,
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
      ),
    );
  }
}
