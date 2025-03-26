import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/providers/keyword_provider.dart';
import 'package:notiskku/widget/search/search_keyword.dart';
import 'package:notiskku/widget/list/list_keyword.dart';

class ScreenMainKeywordEdit extends ConsumerStatefulWidget {
  const ScreenMainKeywordEdit({Key? key}) : super(key: key);

  @override
  ConsumerState<ScreenMainKeywordEdit> createState() => _ScreenMainKeywordEditState();
}

class _ScreenMainKeywordEditState extends ConsumerState<ScreenMainKeywordEdit> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keywordState = ref.watch(keywordProvider);
    // "설정 완료" 버튼 활성화 조건 (예시로 선택된 키워드가 있거나 '선택하지 않음'이면 활성화)
    final isButtonEnabled = keywordState.selectedKeywords.isNotEmpty || keywordState.isDoNotSelect;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '키워드',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black), // 뒤로가기 아이콘 색상
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 10.h),
          // 안내 문구(종 모양) 제거됨.
          // 검색창 위젯
          SearchKeyword(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
            onClear: () {
              _searchController.clear();
              setState(() {
                _searchText = '';
              });
            },
          ),
          // 키워드 목록 위젯
          Expanded(
            child: ListKeyword(searchText: _searchText),
          ),
          // 하단 "설정 완료" 버튼
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
            child: ElevatedButton(
              onPressed: isButtonEnabled
                  ? () {
                      // "설정 완료" 시 필요한 로직 (예: 선택된 키워드 저장, 이전 화면 복귀)
                      Navigator.pop(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B5B42),
                disabledBackgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Text(
                  '설정 완료',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
