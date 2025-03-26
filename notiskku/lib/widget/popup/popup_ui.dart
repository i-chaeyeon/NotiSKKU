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
      // contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      contentPadding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 400.h, // 400px, 640px 화면 기준
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0B5B42),
                ),
              ),
              Divider(
                color: const Color(0xFF0B5B42),
                thickness: 2.h,
                height: 10.h,
              ),
              SizedBox(height: 10.h),
              content, // 내용 
              SizedBox(height: 20.h),
              Align( // 확인 버튼 
                alignment: Alignment.center, 
                child: SizedBox(
                  width: 80.w,
                  height: 27.h,
                  child: ElevatedButton( // 피그마 80X27 px
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B5B42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          confirmText,
                          style: TextStyle(color: Colors.white, fontSize: 15.sp),
                        ),
                      ),
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
