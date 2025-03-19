import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/providers/list_notices_provider.dart';
import 'package:notiskku/tabs/screen_main_search.dart';
import 'package:notiskku/widget/bar/bar_categories.dart';
import 'package:notiskku/widget/bar/bar_notices.dart';
import 'package:notiskku/widget/list/list_notices.dart';

class ScreenMainNotice extends ConsumerWidget {
  const ScreenMainNotice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeAsync = ref.watch(listNoticesProvider);

    return Scaffold(
      appBar: const _NoticeAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          BarNotices(),
          SizedBox(height: 6.h),
          BarCategories(),
          SizedBox(height: 10.h),
          Expanded(
            child: noticeAsync.when(
              data: (notices) => ListNotices(notices: notices),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) {
                debugPrint('Error fetching notices: $error');
                return Center(child: Text('Failed to load notices: $error'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _NoticeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final majorState = ref.watch(majorProvider);
    final selectedMajorsText =
        majorState.selectedMajors.isNotEmpty
            ? majorState.selectedMajors.join(', ')
            : '학과를 선택하세요';

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(10.0),
        child: Image.asset('assets/images/greenlogo_fix.png', width: 40),
      ),
      title: Text(
        selectedMajorsText,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScreenMainSearch(),
                  ),
                );
              },
              child: Image.asset('assets/images/search_fix.png', width: 30),
            ),
          ),
        ],
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
