import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/widget/button/button_searched.dart';
import 'package:notiskku/widget/list/list_recent_search.dart';
import 'package:notiskku/widget/search/search_notice.dart';


class ScreenMainSearch extends ConsumerStatefulWidget {
  const ScreenMainSearch({super.key});

  @override
  _ScreenMainSearchState createState() => _ScreenMainSearchState();
}

class _ScreenMainSearchState extends ConsumerState<ScreenMainSearch> {
  String searchText = '';
  bool isSearched = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF979797),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '검색',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true, // 제목 중앙 정렬
        actions: const [
          SizedBox(width: 40), // 오른쪽 여백 추가
        ],
      ),

      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 10),
          SearchNotice(
            onSearchChanged: (newText) {
              setState(() {
                searchText = newText;
                isSearched = newText.isNotEmpty;
              });
            },
          ),
          const SizedBox(height: 5),

          // isSearched 상태에 따라 다른 위젯 표시
          if (!isSearched)
            // 최근 검색 내역 (isSearched가 false일 때)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '최근 검색 내역',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            // 검색 결과 (isSearched가 true일 때)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '검색 결과',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          // isSearched 상태에 따른 컨텐츠 (최근 검색 내역 또는 검색 결과)
          Expanded(
            child:
                isSearched
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: 10, // 검색 결과의 개수를 설정
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('검색 결과 #$index'),
                            subtitle: Text('검색어 "$searchText"에 대한 결과입니다.'),
                          );
                        },
                      ),
                    )
                    : ListRecentSearch(),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
