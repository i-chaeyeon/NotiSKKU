import 'package:flutter/material.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/widget/notice_tile.dart';

class ListStarredNotices extends StatelessWidget {
  final List<Notice> starredNotices;

  const ListStarredNotices({super.key, required this.starredNotices});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: starredNotices.length,
      itemBuilder: (context, index) {
        return NoticeTile(notice: starredNotices[index]);
      },
    );
  }
}
