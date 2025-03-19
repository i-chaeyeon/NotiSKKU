import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/screen/screen_intro_two.dart';
import 'package:notiskku/widget/button/wide_green.dart';

// 성균관대 공지사항 어플 NotiSKKU를 소개합니다! 
class ScreenIntroOne extends StatelessWidget {
  const ScreenIntroOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20.h), // Optional space for top padding
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 36.w,
                    ), // 10%의 가로 여백
                    child: Text(
                      '성균관대 공지사항 어플',
                      style: TextStyle(
                        fontSize: 17.sp, // 반응형 폰트 크기
                        fontFamily: 'GmarketSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 36.w,
                    ), // 10%의 가로 여백
                    child: Text.rich(
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
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(height: 52.h),
                Image.asset(
                  'assets/images/first_fix.png',
                  width: 206.w,
                  height: 202.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIndicatorCircle(color: const Color(0xff0b5b42)),
                    SizedBox(width: 26.w),
                    _buildIndicatorCircle(color: Colors.grey),
                    SizedBox(width: 26.w),
                    _buildIndicatorCircle(color: Colors.grey),
                  ],
                ),
                SizedBox(height: 88.h),
                Padding( // WideGreen 버튼, 다음으로
                  padding: EdgeInsets.only(bottom: 40.h), // 반응형 하단 여백
                  child: WideGreen( 
                    text: '다음으로',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScreenIntroTwo(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// ● ○ ○ indicator 
  Widget _buildIndicatorCircle({required Color color}) {
    return Container(
      width: 10.w, // 반응형 원 크기
      height: 10.h,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
