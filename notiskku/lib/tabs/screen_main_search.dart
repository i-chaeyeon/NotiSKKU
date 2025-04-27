import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:notiskku/widget/button/button_searched.dart';
import 'package:notiskku/widget/list/list_recent_search.dart';
import 'package:notiskku/widget/list/list_search_results.dart';
import 'package:notiskku/widget/search/search_notice.dart';

class ScreenMainSearch extends ConsumerStatefulWidget {
  const ScreenMainSearch({super.key});

  @override
  ScreenMainSearchState createState() => ScreenMainSearchState();
}

class ScreenMainSearchState extends ConsumerState<ScreenMainSearch> {
  String searchText = '';
  bool isSearched = false;

  // 검색 상태 업데이트
  void updateSearch(String newText, bool searched) {
    setState(() {
      searchText = newText;
      isSearched = searched;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF979797)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '검색',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true, // 제목 중앙 정렬
        actions: [
          SizedBox(width: 40.w), // 오른쪽 여백 추가
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 10),
          SearchNotice(
            onSearch: updateSearch,
          ), // `onSearch`를 사용하여 검색 실행 시 상태 변경
          SizedBox(height: 5.h),
          // 검색 상태에 따라 '최근 검색 내역' 또는 '검색 결과' 표시
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isSearched ? "‘$searchText’에 대한 검색 결과" : '최근 검색 내역',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // 최근 검색 내역 또는 검색 결과 표시
          Expanded(
            child:
                isSearched
                    ? ListSearchResults(searchText: searchText)
                    : ListRecentSearch(
                      onTapRecentSearch: (text) => updateSearch(text, true),
                    ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
