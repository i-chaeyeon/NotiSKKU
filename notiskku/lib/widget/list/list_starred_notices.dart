import 'package:flutter/material.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/widget/notice_tile.dart';

class ListStarredNotices extends StatelessWidget {
  final List<Notice> notices;

  const ListStarredNotices({super.key, required this.notices});

  @override
  Widget build(BuildContext context) {
    if (notices.isEmpty) {
      return const Center(
        child: Text(
          '저장된 공지가 없습니다',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: notices.length,
      itemBuilder: (BuildContext context, int index) {
        final notice = notices[index];
        return NoticeTile(notice: notice);
      },
    );
  }
}
