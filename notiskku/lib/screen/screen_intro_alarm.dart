import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/screen/screen_intro_loading.dart';
import 'package:notiskku/screen/screen_intro_ready.dart';
import 'package:notiskku/widget/grid/grid_alarm_keyword.dart';
import 'package:notiskku/widget/list/list_alarm_major.dart';
import 'package:notiskku/widget/button/wide_green.dart';
import 'package:notiskku/widget/dialog/dialog_no_alarm.dart';

// AppPreferences 사용해 이후 어플 최초 실행인지 상태 관리 구현 필요
// AppPreferences는 구현 완료 (세팅하고 쓰면 됨)
// 제거되는 부분: isFromOthers
class ScreenIntroAlarm extends ConsumerWidget {
  const ScreenIntroAlarm({super.key, this.isFromOthers = false});
  final bool isFromOthers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMajors = ref.watch(userProvider).selectedMajors;
    final selectedKeywords = ref.watch(userProvider).selectedKeywords;

    return Scaffold(
      // ▶ AppBar 추가
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.w),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 20.h),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                '알림 받을 학과와 키워드를 선택해주세요😀\n미선택 시 알림이 발송되지 않습니다.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black.withAlpha(229),
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
              if (selectedMajors.every((m) => m.receiveNotification == false) &&
                  selectedKeywords.every(
                    (k) => k.receiveNotification == false,
                  )) {
                _showNoAlarmDialog(context);
              } else {
                _goToNext(context);
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
        MaterialPageRoute(builder: (context) => const ScreenIntroLoading()),
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
