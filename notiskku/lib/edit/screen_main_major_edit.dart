import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// MajorProvider와 ListMajor 위젯을 사용하기 위해 import
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/widget/button/wide_condition.dart';
import 'package:notiskku/widget/list/list_major.dart';

class ScreenMainMajorEdit extends ConsumerWidget {
  const ScreenMainMajorEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // majorProvider 상태를 구독
    final majorState = ref.watch(majorProvider);

    // 버튼 활성화 조건: 선택된 학과가 1개 이상일 때
    // (필요에 따라 2개가 정확히 선택되어야만 활성화 등으로 바꿀 수도 있음)
    final isButtonEnabled = majorState.selectedMajors.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          '학과 선택 편집',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black), // 뒤로가기 화살표 색상
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 10.h),
          // 안내 문구
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                '관심 학과를 선택해주세요😀\n(학과는 최대 2개까지 가능)',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.9),
                  fontSize: 14.sp,
                  fontFamily: 'GmarketSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // 검색창 + 학과 리스트
          Expanded(child: ListMajor()),
          SizedBox(height: 30.h),
          // 설정 완료 버튼
          WideCondition(
            text: '설정 완료',
            isEnabled: isButtonEnabled,
            onPressed:
                isButtonEnabled
                    ? () {
                      ref
                          .read(majorProvider.notifier)
                          .updateSearchText(''); // 수동 초기화
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
