import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/widget/wide_green.dart';
import 'package:notiskku/widget/wide_grey.dart';

class ScreenIntroThree extends StatelessWidget {
  const ScreenIntroThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20.h), // 반응형 상단 여백
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 36.w,
                    ), // 반응형 가로 여백
                    child: IntrinsicHeight(
                      // 텍스트와 이미지 높이를 동일하게 맞춤
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontFamily: 'GmarketSans',
                          ),
                          children: [
                            TextSpan(text: '중요한 소식, 내가 먼저!'),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Image.asset(
                                'assets/images/medal.png',
                                width: 35.w,
                                height: 35.h,
                                // fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 36.w,
                    ), // 반응형 가로 여백
                    child: Text(
                      '띠링~ 필요한 알림만 받을 수 있어요.',
                      style: TextStyle(
                        fontFamily: 'GmarketSans',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 49.h),
                Image.asset(
                  'assets/images/third_fix.png',
                  width: 204.w,
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
                    _buildIndicatorCircle(color: Colors.grey),
                    SizedBox(width: 26.w),
                    _buildIndicatorCircle(color: Colors.grey),
                    SizedBox(width: 26.w),
                    _buildIndicatorCircle(color: const Color(0xff0b5b42)),
                  ],
                ),
                SizedBox(height: 36.h),
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: WideGrey(text: '다음에 설정하기', onPressed: () {}),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 40.h), // 반응형 하단 여백
                  child: WideGreen(
                    text: '다음으로',
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const SecondScreen()),
                      // );
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

  // Indicator Circle 생성 메서드
  Widget _buildIndicatorCircle({required Color color}) {
    return Container(
      width: 10.w, // 반응형 크기
      height: 10.h,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
