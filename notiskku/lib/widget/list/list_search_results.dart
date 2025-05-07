import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/data/major_data.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/providers/selected_major_provider.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/widget/list/list_notices.dart';

class ListSearchResults extends ConsumerStatefulWidget {
  final String searchText;
  final Notices typeState;

  const ListSearchResults({
    super.key,
    required this.searchText,
    required this.typeState,
  });

  @override
  ConsumerState<ListSearchResults> createState() => _ListSearchResultsState();
}

class _ListSearchResultsState extends ConsumerState<ListSearchResults> {
  Future<Widget> getSearchResults(String searchText, Notices typeState) async {
    final userState = ref.watch(userProvider);
    final majorIndex = ref.watch(selectedMajorIndexProvider);
    final typeState = ref.watch(barNoticesProvider);

    final currentMajor =
        userState.selectedMajors.isEmpty
            ? ''
            : userState
                .selectedMajors[majorIndex.clamp(
                  0,
                  userState.selectedMajors.length - 1,
                )]
                .major;

    final currentDept =
        majors.firstWhere((m) => m.major == currentMajor).department;
    late QuerySnapshot snapshot;

    if (typeState == Notices.common) {
      snapshot =
          await FirebaseFirestore.instance
              .collection('notices')
              .where('type', isEqualTo: "전체")
              .orderBy('date', descending: true)
              .get();
    } else if (typeState == Notices.dept) {
      snapshot =
          await FirebaseFirestore.instance
              .collection('notices')
              .where('department', isEqualTo: currentDept)
              .orderBy('date', descending: true)
              .get();
    } else if (typeState == Notices.major) {
      snapshot =
          await FirebaseFirestore.instance
              .collection('notices')
              .where('type', isEqualTo: "학과")
              .where('major', isEqualTo: currentMajor)
              .orderBy('date', descending: true)
              .get();
    }

    final results =
        snapshot.docs
            .where(
              (doc) => doc['title'].toString().toLowerCase().contains(
                searchText.toLowerCase(),
              ),
            )
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['hash'] = doc.id;
              return data;
            })
            .toList();

    return ListNotices(notices: results);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<Widget>(
        future: getSearchResults(widget.searchText, widget.typeState),
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
