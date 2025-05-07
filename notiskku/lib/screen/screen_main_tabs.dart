import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/data/temp_starred_notices.dart';
import 'package:notiskku/providers/user/user_provider.dart';
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

class ScreenMainTabs extends ConsumerStatefulWidget {
  const ScreenMainTabs({super.key});

  @override
  ConsumerState<ScreenMainTabs> createState() => _ScreenMainTabsState();
}

class _ScreenMainTabsState extends ConsumerState<ScreenMainTabs> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ScreenMainNotice(),
    ScreenMainKeyword(),
    ScreenMainBox(),
    ScreenMainCalender(),
    ScreenMainOthers(),
  ];

  List<BottomNavigationBarItem> get _navItems => [
    _buildNavItem('assets/images/notice_fix.png', '공지사항'),
    _buildNavItem('assets/images/keyword_fix.png', '키워드'),
    _buildNavItem('assets/images/emptystar_fix.png', '즐겨찾기'),
    _buildNavItem('assets/images/calendar_fix.png', '학사일정'),
    _buildNavItem('assets/images/more_fix.png', '더보기'),
  ];

  BottomNavigationBarItem _buildNavItem(String assetPath, String label) {
    return BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(assetPath), size: 30.w),
      label: label,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // ✅ ref 사용 가능
    ref.read(userProvider.notifier).saveTempStarred(tempStarredNotices);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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
