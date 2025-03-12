import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/notice_functions/launch_url.dart';
import 'package:notiskku/providers/notice_list_provider.dart';
import 'package:notiskku/providers/starred_provider.dart';

class ListNotices extends StatelessWidget {
  final List<Notice> notices;
  

  const ListNotices({Key? key, required this.notices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notices.length,
      itemBuilder: (context, index) {
        return NoticeTile(notice: notices[index]);
      },
    );
  }
}

class NoticeTile extends ConsumerWidget {
  final Notice notice;
  final LaunchUrlService launchUrlService = LaunchUrlService(); // ✅ 인스턴스 생성

  NoticeTile({Key? key, required this.notice}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStarred = ref.watch(starredProvider);

    return Column(
      children: [
        ListTile(
          title: Text(
            notice.title,
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          subtitle: Text('${notice.date} | 조회수: ${notice.views}'),
          trailing: GestureDetector(
            onTap: () {
              ref.read(starredProvider.notifier).toggleNotice(notice);
            },
            child: Image.asset(
              isStarred.any((n) => n.url == notice.url)
                  ? 'assets/images/fullstar_fix.png'
                  : 'assets/images/emptystar_fix.png',
              width: 26,
              height: 26,
            ),
          ),
          onTap: () async {
            await launchUrlService.launchURL(notice.url); // ✅ 인스턴스 사용하여 메서드 호출
          },
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 16,
          endIndent: 16,
        ),
      ],
    );
  }
}

