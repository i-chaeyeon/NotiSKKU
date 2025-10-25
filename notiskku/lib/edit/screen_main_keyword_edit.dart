import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:notiskku/models/keyword.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/providers/user/user_state.dart';
import 'package:notiskku/widget/button/wide_condition.dart';
import 'package:notiskku/widget/search/search_keyword.dart';
import 'package:notiskku/widget/list/list_keyword.dart';
import 'package:notiskku/screen/screen_intro_loading.dart';

class ScreenMainKeywordEdit extends ConsumerStatefulWidget {
  const ScreenMainKeywordEdit({super.key});

  @override
  ConsumerState<ScreenMainKeywordEdit> createState() =>
      _ScreenMainKeywordEditState();
}

class _ScreenMainKeywordEditState extends ConsumerState<ScreenMainKeywordEdit> {
  late final List<Keyword> _originalKeywords;
  late final bool _originalDoNotSelect;
  bool _committed = false;

  // 원복 중 자동토글 방지
  bool _isRestoring = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);

    _originalKeywords = user.selectedKeywords
        .map(
          (k) => Keyword(
            id: k.id,
            keyword: k.keyword,
            defined: k.defined,
            receiveNotification: k.receiveNotification,
          ),
        )
        .toList(growable: false);

    _originalDoNotSelect = user.doNotSelectKeywords;
  }

  void _restoreIfNotCommitted() {
    if (_committed) return;

    _isRestoring = true;

    // 1) 키워드 목록 복원 (이 메서드는 doNotSelectKeywords를 false로 만듭니다)
    ref.read(userProvider.notifier).replaceSelectedKeywords(_originalKeywords);

    // 2) 원래 플래그로 복원
    final now = ref.read(userProvider).doNotSelectKeywords;
    if (now != _originalDoNotSelect) {
      // post-frame에서 토글 → 빌드 타이밍 충돌 방지
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(userProvider.notifier).toggleDoNotSelectKeywords();
      });
    }

    // 한 프레임 뒤에 복원 종료
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isRestoring = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    // ✅ 자동 토글: 선택 키워드가 0개가 되는 순간 doNotSelectKeywords = true
    ref.listen(userProvider, (prev, next) {
      // 원복중/커밋후/이미 true면 동작 안 함
      if (_isRestoring || _committed || !mounted) return;
      final becameEmpty = next.selectedKeywords.isEmpty;
      final notYetFlag = !next.doNotSelectKeywords;
      if (becameEmpty && notYetFlag) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ref.read(userProvider.notifier).toggleDoNotSelectKeywords();
        });
      }
    });

    // "설정 완료" 버튼 활성화 조건 (비어있어도 '선택하지 않음'이면 활성화)
    final isButtonEnabled =
        userState.selectedKeywords.isNotEmpty || userState.doNotSelectKeywords;

    final searchText = userState.currentSearchText;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        _restoreIfNotCommitted();
      },
      child: Scaffold(
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

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
              child: const SearchKeyword(),
            ),

            Expanded(child: ListKeyword(searchText: searchText)),

            SizedBox(height: 30.h),

            WideCondition(
              text: '설정 완료',
              isEnabled: isButtonEnabled,
              onPressed:
                  isButtonEnabled
                      ? () async {
                        final user = ref.read(userProvider);

                        debugPrint('-----------------------------');
                        debugPrint(
                          '⚙️ [ScreenMainKeywordEdit] 키워드 편집 완료 → 로딩 화면으로 이동',
                        );
                        debugPrint(
                          '선택된 키워드: ${user.selectedKeywords.map((k) => k.keyword).join(", ")}',
                        );
                        debugPrint(
                          '선택하지 않음(doNotSelectKeywords): ${user.doNotSelectKeywords}',
                        );
                        debugPrint(
                          '현재 검색어(currentSearchText): ${user.currentSearchText}',
                        );
                        debugPrint('-----------------------------');

                        _committed = true; // 완료 확정 → 뒤로가기 복원 방지

                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => const ScreenIntroLoading(
                                  isFromOthers: true,
                                ),
                          ),
                        );
                      }
                      : null,
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
