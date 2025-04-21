import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notiskku/widget/list/list_notices.dart';

class ListSearchResults extends StatefulWidget {
  final String searchText;
  const ListSearchResults({super.key, required this.searchText});

  @override
  State<ListSearchResults> createState() => _ListSearchResultsState(); // 클래스명 수정
}

class _ListSearchResultsState extends State<ListSearchResults> {
  Future<Widget> getSearchResults(String searchText) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('notices')
            .orderBy('date', descending: true)
            .get();

    final results =
        snapshot.docs
            .where(
              (doc) => doc['title'].toString().toLowerCase().contains(
                searchText.toLowerCase(),
              ),
            )
            .map((doc) {
              final data = doc.data();
              data['hash'] = doc.id;
              return data;
            })
            .toList();

    return ListNotices(notices: results);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: FutureBuilder<Widget>(
        future: getSearchResults(widget.searchText),
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
