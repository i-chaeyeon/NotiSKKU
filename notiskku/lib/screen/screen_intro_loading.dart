import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/screen/screen_intro_ready.dart';

class ScreenIntroLoading extends StatefulWidget {
  const ScreenIntroLoading({super.key});

  @override
  State<ScreenIntroLoading> createState() => _ScreenIntroLoadingState();
}

class _ScreenIntroLoadingState extends State<ScreenIntroLoading> {
  // 일단 2초 뒤 넘어가는 것으로 설정해 둠
  // 실제로는 데이터 저장(firebase) 완료되면 넘어가도록 설정할 예정 !!!!
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ScreenIntroReady()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 60.h), // 반응형 상단 여백
            Column(
              children: [
                Image.asset(
                  'assets/images/fourth_fix.png',
                  height: 170.h, // Image size based on screen height
                  width: 170.h, // Image width based on screen width
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 23.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '로딩 중...',
                      style: TextStyle(
                        color: Color(0xFF0B5B42),
                        fontSize: 24.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
