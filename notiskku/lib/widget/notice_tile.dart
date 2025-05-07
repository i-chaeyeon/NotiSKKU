import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/notice_functions/launch_url.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class NoticeTile extends ConsumerWidget {
  final Map<String, dynamic> notice;
  final LaunchUrlService launchUrlService = LaunchUrlService();

  NoticeTile({super.key, required this.notice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final starredNotices = ref.watch(userProvider).starredNotices;

    final title = notice['title'] ?? '';
    final date = notice['date'] ?? '';
    final views = notice['views'] ?? '';
    final link = notice['url'] ?? '';
    final hash = notice['hash'] ?? '';

    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(fontSize: 15.sp, color: Colors.black),
          ),
          subtitle: Text(
            views == 'null' ? '$date | 조회수: -' : '$date | 조회수: $views',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          trailing: GestureDetector(
            onTap: () {
              ref.read(userProvider.notifier).toggleStarredNotice(hash);
            },
            child: Image.asset(
              starredNotices.contains(hash)
                  ? 'assets/images/fullstar_fix.png'
                  : 'assets/images/emptystar_fix.png',
              width: 26.w,
              height: 26.h,
            ),
          ),
          onTap: () {
            launchUrlService.launchURL(link);
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 1.h,
          indent: 16.w,
          endIndent: 16.w,
        ),
      ],
    );
  }
}
