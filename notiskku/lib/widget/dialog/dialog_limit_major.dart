import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogLimitMajor extends StatelessWidget {
  final List<String> selectedMajors;

  const DialogLimitMajor({super.key, required this.selectedMajors});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      backgroundColor: Colors.white,
      title: Text(
        '⚠️ 전공 선택 제한',
        style: TextStyle(
          color: const Color(0xFF0B5B42),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('전공은 최대 두 개까지 선택할 수 있습니다.', style: TextStyle(fontSize: 14.sp)),
          SizedBox(height: 10.h),
          Text(
            "선택한 전공:\n${selectedMajors.join('\n')}",
            style: TextStyle(fontSize: 13.sp),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('확인', style: TextStyle(fontSize: 16.sp, color: Colors.black)),
        ),
      ],
    );
  }
}
