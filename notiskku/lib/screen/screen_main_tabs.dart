import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:notiskku/data/temp_starred_notices.dart';
import 'package:notiskku/providers/tab_providers.dart';
import 'package:notiskku/providers/user/user_provider.dart';

import 'package:notiskku/tabs/screen_main_keyword.dart';
import 'package:notiskku/tabs/screen_main_notice.dart';
import 'package:notiskku/tabs/screen_main_box.dart';
import 'package:notiskku/tabs/screen_main_calender.dart';
import 'package:notiskku/tabs/screen_main_others.dart';
import 'package:notiskku/screen/screen_intro_alarm.dart'; // ✅ 바로가기 대상 import

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context, child) {
        return const ProviderScope(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ScreenMainTabs(),
          ),
        );
      },
    );
  }
}

class ScreenMainTabs extends ConsumerStatefulWidget {
  const ScreenMainTabs({super.key, this.showPostLoadNotice = false});
  final bool showPostLoadNotice;

  @override
  ConsumerState<ScreenMainTabs> createState() => _ScreenMainTabsState();
}

class _ScreenMainTabsState extends ConsumerState<ScreenMainTabs> {
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

  @override
  void initState() {
    super.initState();
    if (widget.showPostLoadNotice) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showPostLoadNotice(context);
      });
    }
  }

  void _onItemTapped(int newIndex) {
    final previousIndex = ref.read(tabIndexProvider);
    final userNotifier = ref.read(userProvider.notifier);

    if (previousIndex == 2) {
      userNotifier.deleteTempStarred(tempStarredNotices);
    } else {
      userNotifier.saveTempStarred(tempStarredNotices);
    }

    ref.read(tabIndexProvider.notifier).state = newIndex;
  }

  void _showPostLoadNotice(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              '편집이 완료되었습니다!',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            content: Text(
              '새로 추가한 학과/키워드에 대한 알림은\n'
              '더보기 > 학과 및 키워드 알림 설정에서\n설정할 수 있습니다 😄',
              style: TextStyle(fontSize: 12.sp),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // ✅ 기본 패딩 제거
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => const ScreenIntroAlarm(isFromOthers: true),
                    ),
                  );
                },
                child: Text(
                  '알림 설정 바로가기',
                  style: TextStyle(
                    color: Color(0xFF979797),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // ✅ 기본 패딩 제거
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                ),
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text(
                  '확인',
                  style: TextStyle(
                    color: Color(0xFF0B5B42),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(tabIndexProvider);

    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.white,
        items: _navItems,
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF0B5B42),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14.sp,
        unselectedFontSize: 14.sp,
        onTap: _onItemTapped,
      ),
    );
  }
}
