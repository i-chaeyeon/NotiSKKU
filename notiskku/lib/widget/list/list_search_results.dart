import 'package:flutter/material.dart';

class ListSearchResults extends StatefulWidget {
  final String searchText;

  const ListSearchResults({super.key, required this.searchText});

  @override
  State<ListSearchResults> createState() => _ListSearchResultsState(); // 클래스명 수정
}

class _ListSearchResultsState extends State<ListSearchResults> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: 10, // 검색 결과 개수
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('검색 결과 #$index'),
            subtitle: Text('검색어 "${widget.searchText}"에 대한 결과입니다.'), // widget.searchText로 수정
          );
        },
      ),
    );
  }
}
