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

class ScreenIntroAlarm extends ConsumerWidget {
  const ScreenIntroAlarm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final majorState = ref.watch(majorProvider);
    final keywordState = ref.watch(keywordProvider);

    final selectedAlarmMajors = majorState.alarmMajors;
    final selectedAlarmKeywords = keywordState.alarmKeywords;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80.h),

            Text(
              '알림 받을 학과와 키워드를 선택해주세요😀\n미선택 시 알림이 발송되지 않습니다.',
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'GmarketSans',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20.h),

            Text('선택한 학과', style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 10.h),
            const ListAlarmMajor(),

            SizedBox(height: 30.h),

            Text('선택한 키워드', style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 10.h),
            const Expanded(child: GridAlarmKeyword()),

            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: WideGreen(
                text: '설정 완료',
                onPressed: () {
                  if (selectedAlarmMajors.isNotEmpty || selectedAlarmKeywords.isNotEmpty) {
                    _goToNext(context);
                  } else {
                    _showNoAlarmDialog(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScreenIntroReady()),
    );
  }

  void _showNoAlarmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DialogNoAlarm(onConfirm: () => _goToNext(context)),
    );
  }
}
