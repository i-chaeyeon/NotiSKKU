import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/providers/keyword_provider.dart';
import 'package:notiskku/screen/screen_intro_ready.dart';
import 'package:notiskku/widget/grid/grid_alarm_keyword.dart';
import 'package:notiskku/widget/list/list_alarm_major.dart';
import 'package:notiskku/widget/button/wide_green.dart';
import 'package:notiskku/widget/dialog/dialog_no_alarm.dart';

// 알림 받을 학과와 키워드를 선택해주세요
class ScreenIntroAlarm extends ConsumerWidget {
  const ScreenIntroAlarm({super.key, this.isFromOthers = false});
  final bool isFromOthers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMajors = ref.watch(majorProvider).selectedMajors;
    final selectedKeywords = ref.watch(keywordProvider).selectedKeywords;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 80.h),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                '알림 받을 학과와 키워드를 선택해주세요😀\n미선택 시 알림이 발송되지 않습니다.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.9),
                  fontSize: 14.sp,
                  fontFamily: 'GmarketSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                '선택한 학과',
                style: TextStyle(
                  fontSize: 19.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          const ListAlarmMajor(),

          SizedBox(height: 13.h),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                '선택한 키워드',
                style: TextStyle(
                  fontSize: 19.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          const GridAlarmKeyword(),

          WideGreen(
            text: '설정 완료',
            onPressed: () {
              if (selectedMajors.isNotEmpty || selectedKeywords.isNotEmpty) {
                _goToNext(context);
              } else {
                _showNoAlarmDialog(context);
              }
            },
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  // void _goToNext(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const ScreenIntroReady()),
  //   );
  // }
  void _goToNext(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const ScreenIntroReady()),
    // );
    if (isFromOthers) {
      // screen_main_others에서 진입한 경우: 이전 화면으로 돌아감.
      Navigator.pop(context);
    } else {
      // 초기 시작 시: ScreenIntroReady로 이동.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScreenIntroReady()),
      );
    }
  }

  void _showNoAlarmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DialogNoAlarm(onConfirm: () => _goToNext(context)),
    );
  }
}
