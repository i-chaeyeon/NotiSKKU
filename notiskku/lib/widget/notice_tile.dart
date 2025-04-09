import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/notice_functions/launch_url.dart';
import 'package:notiskku/providers/starred_provider.dart';

class NoticeTile extends ConsumerWidget {
  final Notice notice;
  final LaunchUrlService launchUrlService = LaunchUrlService(); // 인스턴스 생성

  NoticeTile({super.key, required this.notice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final starredNotices = ref.watch(starredProvider).starredNotices;

    return Column(
      children: [
        ListTile(
          title: Text(
            notice.title,
            style: TextStyle(fontSize: 15.sp, color: Colors.black),
          ),
          subtitle: Text(
            '${notice.date} | 조회수: ${notice.views}',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          trailing: GestureDetector(
            onTap: () {
              ref.read(starredProvider.notifier).toggleNotice(notice);
            },
            child: Image.asset(
              starredNotices.any(
                    (n) => n.title == notice.title && n.id == notice.id,
                  )
                  ? 'assets/images/fullstar_fix.png'
                  : 'assets/images/emptystar_fix.png',
              width: 26.w,
              height: 26.h,
            ),
          ),
          onTap: () async {
            await launchUrlService.launchURL(notice.link); // 인스턴스 사용하여 메서드 호출
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
