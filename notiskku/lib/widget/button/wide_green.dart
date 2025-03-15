import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WideGreen extends StatelessWidget {
  final String text; // 버튼 텍스트
  final VoidCallback? onPressed; // 클릭 이벤트 인자로 받음 (null 허용)

  const WideGreen({
    super.key,
    required this.text,
    this.onPressed, // 기본값 null → null이면 버튼 비활성화
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 301.w, // 버튼의 고정 너비 (반응형 적용)
      height: 40.h, // 버튼의 고정 높이 (반응형 적용)
      child: TextButton(
        onPressed: onPressed, // 외부에서 전달된 함수 사용
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xff0b5b42), // 배경색
          disabledBackgroundColor: Colors.grey, // 비활성화 시 배경색
          // padding: EdgeInsets.symmetric(vertical: 10.5.h),
          // textStyle: TextStyle(
          //   fontSize: 15.sp,
          //   fontWeight: FontWeight.bold,
          // ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r), // 반응형 둥근 모서리
          ),
        ),
        child: Center(
          // 텍스트를 버튼 중앙에 배치
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
