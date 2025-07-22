import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/data/temp_starred_notices.dart';
import 'package:notiskku/notice_functions/launch_url.dart';
import 'package:notiskku/providers/tab_providers.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class NoticeTile extends ConsumerStatefulWidget {
  final Map<String, dynamic> notice;

  const NoticeTile({super.key, required this.notice});

  @override
  ConsumerState<NoticeTile> createState() => _NoticeTileState();
}

class _NoticeTileState extends ConsumerState<NoticeTile> {
  final launchUrlService = LaunchUrlService();

  @override
  Widget build(BuildContext context) {
    final hash = widget.notice['hash'] ?? '';
    final title = widget.notice['title'] ?? '';
    final date = widget.notice['date'] ?? '';
    final views = widget.notice['views'] ?? '';
    final link = widget.notice['url'] ?? '';

    final starredNotices = ref.watch(userProvider).starredNotices;
    final currentTab = ref.watch(tabIndexProvider);

    return Column(
      children: [
        ListTile(
          title: Text(title, style: TextStyle(fontSize: 15.sp)),
          subtitle: Text(
            views == 'null' ? '$date | 조회수: -' : '$date | 조회수: $views',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          trailing: GestureDetector(
            onTap: () {
              setState(() {
                if (tempStarredNotices.contains(hash)) {
                  tempStarredNotices.remove(hash);
                } else {
                  tempStarredNotices.add(hash);
                }
              });
            },
            child: Image.asset(
              (currentTab == 2)
                  ? !tempStarredNotices.contains(hash)
                      ? 'assets/images/fullstar_fix.png'
                      : 'assets/images/emptystar_fix.png'
                  : (starredNotices.contains(hash) ||
                      tempStarredNotices.contains(hash))
                  ? 'assets/images/fullstar_fix.png'
                  : 'assets/images/emptystar_fix.png',
              width: 26.w,
              height: 26.h,
            ),
          ),
          onTap: () => launchUrlService.launchURL(link),
        ),
        Divider(thickness: 1.h, indent: 16.w, endIndent: 16.w),
      ],
    );
  }
}
