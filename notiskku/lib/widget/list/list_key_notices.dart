import 'package:flutter/material.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/widget/notice_tile.dart';

class ListKeyNotices extends StatelessWidget {
  final List<Notice> notices;
  

  const ListKeyNotices({Key? key, required this.notices}) : super(key: key);

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

