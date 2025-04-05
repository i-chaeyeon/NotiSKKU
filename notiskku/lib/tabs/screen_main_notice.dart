import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/providers/list_notices_provider.dart';
import 'package:notiskku/providers/selected_major_provider.dart';
import 'package:notiskku/tabs/screen_main_search.dart';
import 'package:notiskku/widget/bar/bar_categories.dart';
import 'package:notiskku/widget/bar/bar_notices.dart';
import 'package:notiskku/widget/list/list_notices.dart';

class _NoticeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _NoticeAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final majorState = ref.watch(majorProvider);
    final majorIndex = ref.watch(selectedMajorIndexProvider);
    final majorIndexNotifier = ref.read(selectedMajorIndexProvider.notifier);

    final currentMajor =
        majorState
            .selectedMajors[majorIndex.clamp(
              0,
              majorState.selectedMajors.length - 1,
            )]
            .major;
    // final selectedMajorsText =
    //     majorState.selectedMajors.isNotEmpty
    //         ? majorState.selectedMajors.join(', ')
    //         : '공지사항';
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(10.0),
        child: Image.asset('assets/images/greenlogo_fix.png', width: 40),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 좌측 화살표
          majorState.selectedMajors.length > 1
              ? GestureDetector(
                onTap: () {
                  if (majorIndex > 0) {
                    majorIndexNotifier.state--;
                  }
                },
                child: const Icon(Icons.chevron_left, color: Colors.black),
              )
              : const SizedBox.shrink(),

          // 학과 명
          Flexible(
            child: Text(
              currentMajor,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 우측 화살표
          majorState.selectedMajors.length > 1
              ? GestureDetector(
                onTap: () {
                  if (majorIndex < majorState.selectedMajors.length - 1) {
                    majorIndexNotifier.state++;
                  }
                },
                child: const Icon(Icons.chevron_right, color: Colors.black),
              )
              : const SizedBox.shrink(),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScreenMainSearch()),
              );
            },
            child: Image.asset('assets/images/search_fix.png', width: 30.w),
          ),
        ),
      ],
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ScreenMainNotice extends ConsumerWidget {
  const ScreenMainNotice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeState = ref.watch(listNoticesProvider);

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
            child:
                noticeState.notices.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListNotices(notices: noticeState.notices),
          ),
        ],
      ),
    );
  }
}
