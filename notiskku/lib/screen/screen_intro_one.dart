import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 성균관대 공지사항 어플 NotiSKKU를 소개합니다!
class ScreenIntroOne extends StatelessWidget {
  const ScreenIntroOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 36.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.h),
          Text(
            '성균관대 공지사항 어플',
            style: TextStyle(
              fontSize: 17.sp,
              fontFamily: 'GmarketSans',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'NotiSKKU',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontFamily: 'GmarketSans',
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff0b5b42),
                  ),
                ),
                TextSpan(
                  text: '를 소개합니다!',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontFamily: 'GmarketSans',
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 52.h),
          Center(
            child: Image.asset(
              'assets/images/first_fix.png',
              width: 206.w,
              height: 202.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
