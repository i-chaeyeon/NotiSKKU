// lib/widget/dialog/dialog_set_alarm_info.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogSetAlarmInfo extends StatelessWidget {
  const DialogSetAlarmInfo({
    super.key,
    required this.onTapShortcut,
    required this.onTapOk,
  });

  final VoidCallback onTapShortcut;
  final VoidCallback onTapOk;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      title: Text(
        '편집이 완료되었습니다!',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0B5B42),
        ),
      ),
      content: Text(
        '새로 추가된 학과/키워드에 대한 알림은\n'
        '\'더보기 > 학과 및 키워드 알림 설정\'에서\n설정할 수 있습니다.',
        style: TextStyle(fontSize: 12.sp),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(3.0.w),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero,
          ),
          onPressed: onTapShortcut,
          child: Text(
            '알림 설정 바로가기',
            style: TextStyle(
              color: const Color(0xFF979797),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton(
          // style: TextButton.styleFrom(
          //   padding: EdgeInsets.all(3.0.w),
          //   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //   minimumSize: Size.zero,
          // ),
          onPressed: onTapOk,
          child: Text(
            '확인',
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF0B5B42)),
          ),
        ),
      ],
    );
  }
}
