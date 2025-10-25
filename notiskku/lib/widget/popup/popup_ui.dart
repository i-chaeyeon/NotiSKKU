import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopupUi extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback onConfirm;
  final String confirmText;

  const PopupUi({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.confirmText = '확인',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      contentPadding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 400.h, // 최대 높이만 제한 (필요 시 조정 가능)
        ),
        child: IntrinsicHeight(
          // 내용이 짧을 때 팝업 크기를 내용에 맞춤
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0B5B42),
                ),
                textAlign: TextAlign.center,
              ),
              Divider(
                color: const Color(0xFF0B5B42),
                thickness: 2.h,
                height: 10.h,
              ),
              SizedBox(height: 10.h),

              /// Scrollable Content (only if too long)
              Flexible(child: SingleChildScrollView(child: content)),

              SizedBox(height: 20.h),

              /// Confirm Button
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 80.w,
                  height: 27.h,
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B5B42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}
