import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/widget/button/wide_condition.dart';
import 'package:notiskku/widget/search/search_keyword.dart';
import 'package:notiskku/widget/list/list_keyword.dart';
import 'package:notiskku/screen/screen_intro_loading.dart'; // ✅ 추가

class ScreenMainKeywordEdit extends ConsumerWidget {
  const ScreenMainKeywordEdit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    // "설정 완료" 버튼 활성화 조건
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
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 10.h),
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

          // 검색창
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
            child: const SearchKeyword(),
          ),

          // 키워드 리스트
          Expanded(child: ListKeyword(searchText: searchText)),

          SizedBox(height: 30.h),

          // 설정 완료 버튼 (동일 로직 적용)
          WideCondition(
            text: '설정 완료',
            isEnabled: isButtonEnabled,
            onPressed:
                isButtonEnabled
                    ? () async {
                      final user = ref.read(userProvider);

                      // 🔍 디버깅 로그
                      debugPrint('-----------------------------');
                      debugPrint(
                        '⚙️ [ScreenMainKeywordEdit] 키워드 편집 완료 → 로딩 화면으로 이동',
                      );
                      debugPrint(
                        '선택된 키워드: ${user.selectedKeywords.join(", ")}',
                      );
                      debugPrint(
                        '선택하지 않음(doNotSelectKeywords): ${user.doNotSelectKeywords}',
                      );
                      debugPrint(
                        '현재 검색어(currentSearchText): ${user.currentSearchText}',
                      );
                      debugPrint('-----------------------------');

                      // ✅ 로딩 화면으로 이동 (해당 화면에서 syncAll 수행)
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => const ScreenIntroLoading(
                                  isFromOthers: true, // 편집 경유 플래그 (옵션)
                                ),
                          ),
                        );
                      }
                    }
                    : null,
          ),

          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
