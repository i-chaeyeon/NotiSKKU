import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notiskku/widget/list/list_notices.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class ListStarredNotices extends ConsumerWidget {
  const ListStarredNotices({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final hashedStarredNotices = userState.starredNotices;

    if (hashedStarredNotices.isEmpty) {
      return const Center(
        child: Text(
          '저장된 공지가 없습니다',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    Future<Widget> getStarredNoticesWidget(List<String> hashes) async {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('notices')
              .where(FieldPath.documentId, whereIn: hashes)
              .orderBy('date', descending: true)
              .get();

      final notices =
          snapshot.docs.map((doc) {
            final data = doc.data();
            data['hash'] = doc.id;
            return data;
          }).toList();

      return ListNotices(notices: notices);
    }

    return Expanded(
      child: FutureBuilder<Widget>(
        future: getStarredNoticesWidget(hashedStarredNotices),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          } else {
            return snapshot.data ?? const Center(child: Text('공지 없음'));
          }
        },
      ),
    );
  }
}
