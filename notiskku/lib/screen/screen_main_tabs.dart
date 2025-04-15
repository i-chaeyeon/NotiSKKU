import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/tabs/screen_main_keyword.dart';
import 'package:notiskku/tabs/screen_main_notice.dart';
import 'package:notiskku/tabs/screen_main_box.dart';
import 'package:notiskku/tabs/screen_main_calender.dart';
import 'package:notiskku/tabs/screen_main_others.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(scaffoldBackgroundColor: Colors.white),
          home: const ScreenMainTabs(),
        );
      },
    );
  }
}

class ScreenMainTabs extends StatefulWidget {
  const ScreenMainTabs({super.key});

  @override
  State<ScreenMainTabs> createState() => _ScreenMainTabsState();
}

class _ScreenMainTabsState extends State<ScreenMainTabs> {
  int _selectedIndex = 0;

  // 각 탭에 해당하는 페이지 리스트
  final List<Widget> _pages = const [
    ScreenMainNotice(),
    // ScreenMainKeyword(),
    // ScreenMainBox(),
    ScreenMainCalender(),
    ScreenMainOthers(),
  ];

  // 하단 네비게이션 아이템 정의
  List<BottomNavigationBarItem> get _navItems => [
    _buildNavItem('assets/images/notice_fix.png', '공지사항'),
    _buildNavItem('assets/images/keyword_fix.png', '키워드'),
    _buildNavItem('assets/images/bogwan_fix.png', '공지함'),
    _buildNavItem('assets/images/calendar_fix.png', '학사일정'),
    _buildNavItem('assets/images/more_fix.png', '더보기'),
  ];

  // 아이템 구성 메서드
  BottomNavigationBarItem _buildNavItem(String assetPath, String label) {
    return BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(assetPath), size: 30.w),
      label: label,
    );
  }

  // 탭 선택 처리
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // 현재 선택된 페이지 표시
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.white,
        items: _navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF0B5B42),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14.sp,
        unselectedFontSize: 14.sp,
        onTap: _onItemTapped,
      ),
    );
  }
}
