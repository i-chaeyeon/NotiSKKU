import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogNotSaved extends StatelessWidget {
  final VoidCallback onConfirm;

  const DialogNotSaved({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      backgroundColor: Colors.white,
      title: Text(
        '편집을 종료하시겠습니까?',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0B5B42),
        ),
      ),
      content: Text(
        '변경 사항이 저장되지 않습니다. 계속하시겠습니까?',
        style: TextStyle(fontSize: 12.sp),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            '취소',
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFFE64343)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm(); // 확인 누르면 다음 화면 이동
          },
          child: Text(
            '확인',
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF0B5B42)),
          ),
        ),
      ],
    );
  }
}
