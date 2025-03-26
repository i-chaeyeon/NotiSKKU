import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopupUi extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback onConfirm;
  final String confirmText;

  const PopupUi({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.confirmText = '확인',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 0.65.sh, // 화면 높이의 65%
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0B5B42),
                ),
              ),
              Divider(
                color: const Color(0xFF0B5B42),
                thickness: 3.h,
                height: 20.h,
              ),
              SizedBox(height: 10.h),
              content,
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B5B42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Text(
                      confirmText,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
