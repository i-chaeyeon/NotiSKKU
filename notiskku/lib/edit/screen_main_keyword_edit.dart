import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/widget/button/wide_condition.dart';
import 'package:notiskku/widget/search/search_keyword.dart';
import 'package:notiskku/widget/list/list_keyword.dart';

class ScreenMainKeywordEdit extends ConsumerWidget {
  const ScreenMainKeywordEdit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    // "설정 완료" 버튼 활성화 조건 (예시로 선택된 키워드가 있거나 '선택하지 않음'이면 활성화)
    final isButtonEnabled =
        userState.selectedKeywords.isNotEmpty || userState.doNotSelectKeywords;
    final searchText = userState.currentSearchText;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          '키워드 선택 편집',
          style: TextStyle(
            fontSize: 17.sp,
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
          // 안내 문구 추가
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                '관심 키워드를 선택해주세요😀',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontFamily: 'GmarketSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // 2) 검색창
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
            child: SearchKeyword(), // 검색 위젯
          ),

          // 3) 키워드 리스트 (검색어 provider.currentSearchText 를 넘겨줌)
          Expanded(child: ListKeyword(searchText: searchText)),
          SizedBox(height: 30.h),
          // 설정 완료 버튼
          WideCondition(
            text: '설정 완료',
            isEnabled: isButtonEnabled,
            onPressed:
                isButtonEnabled
                    ? () {
                      // "설정 완료" 시 필요한 로직 (예: 선택된 키워드 저장, 이전 화면 복귀)
                      Navigator.pop(context);
                    }
                    : null,
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
