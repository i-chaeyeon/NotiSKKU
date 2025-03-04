import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/screen/screen_intro_three.dart';
import 'package:notiskku/widget/button/wide_green.dart';

class ScreenIntroTwo extends StatelessWidget {
  const ScreenIntroTwo({super.key});

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
                            TextSpan(text: '공지사항도 내 스타일로! '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Image.asset(
                                'assets/images/magic_wand.png',
                                width: 28.w,
                                height: 28.h,
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
                      '원하는 소식만 확인할 수 있어요.',
                      style: TextStyle(
                        fontFamily: 'GmarketSans',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
                Image.asset(
                  'assets/images/second_fix.png',
                  width: 197.w,
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
                    _buildIndicatorCircle(color: const Color(0xff0b5b42)),
                    SizedBox(width: 26.w),
                    _buildIndicatorCircle(color: Colors.grey),
                  ],
                ),
                SizedBox(height: 88.h),
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h), // 반응형 하단 여백
                  child: WideGreen(
                    text: '다음으로',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScreenIntroThree(),
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

  // Indicator Circle 생성 메서드
  Widget _buildIndicatorCircle({required Color color}) {
    return Container(
      width: 10.w, // 반응형 크기
      height: 10.h,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
