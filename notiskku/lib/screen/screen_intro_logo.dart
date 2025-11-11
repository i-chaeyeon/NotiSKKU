import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/screen/screen_intro.dart';
import 'package:notiskku/screen/screen_main_tabs.dart';
import 'package:notiskku/services/preferences_app.dart';

// 3초 후 넘어가는 초록색 NotiSKKU 로고 페이지
class ScreenLogoIntro extends StatefulWidget {
  const ScreenLogoIntro({super.key});

  @override
  State<ScreenLogoIntro> createState() => _ScreenLogoIntroState();
}

class _ScreenLogoIntroState extends State<ScreenLogoIntro> {
  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(seconds: 1), () {
    //   if (!mounted) return;
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const ScreenIntro()),
    //   );
    // });

    Future.delayed(const Duration(seconds: 1), () async {
      final isFirst = await AppPreferences.isFirstLaunch();

      if (isFirst) {
        // await AppPreferences.isFirstLaunch();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenIntro()),
        );
      } else {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenMainTabs()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b5b42),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 265.w,
              child: Image.asset(
                'assets/images/splash_logo_2025.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 15.w),
          ],
        ),
      ),
    );
  }
}
