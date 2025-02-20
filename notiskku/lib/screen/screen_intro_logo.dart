import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenLogoIntro extends StatefulWidget {
  const ScreenLogoIntro({super.key});

  @override
  State<ScreenLogoIntro> createState() => _ScreenLogoIntroState();
}

class _ScreenLogoIntroState extends State<ScreenLogoIntro> {
  @override
  void initState() {
    super.initState();
    // 일정 시간 후에 IntroductionScreen으로 이동
    // Future.delayed(const Duration(seconds: 1), () {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const ScreenIntroOne()),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b5b42),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/whitelogo_fix.png',
              width: 288.w, // 반응형 너비
              height: 160.h, // 반응형 높이
              fit: BoxFit.contain,
            ),
            SizedBox(height: 9.h), // 반응형 간격

            Text(
              'NotiSKKU',
              style: TextStyle(
                fontSize: 40.sp, // 반응형 폰트 크기
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
