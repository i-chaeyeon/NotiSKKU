import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/providers/list_notices_provider.dart';
import 'package:notiskku/widget/side_scroll.dart';

class BarCategories extends ConsumerStatefulWidget {
  const BarCategories({super.key});

  static const categories = [
    '전체',
    '학사',
    '입학',
    '취업',
    '채용/모집',
    '장학',
    '행사/세미나',
    '일반',
  ];

  @override
  _BarCategoriesState createState() => _BarCategoriesState();
}

class _BarCategoriesState extends ConsumerState<BarCategories> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(barCategoriesProvider);
    final notifier = ref.read(barCategoriesProvider.notifier);

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(BarCategories.categories.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(left: 5.w), //
                  child: GestureDetector(
                    onTap: () {
                      // 선택된 카테고리 변경
                      notifier.state = index;
                      // 현재 선택된 학과 가져오기
                      final majorState = ref.read(majorProvider);
                      final majorOrDepartment =
                          majorState.selectedMajors.isNotEmpty
                              ? majorState.selectedMajors[0]
                              : '';
                      // 공지 리스트 강제 새로고침 (FutureProvider 다시 실행)
                      ref.invalidate(listNoticesProvider);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 3.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25.w,
                          vertical: 6.h,
                        ), // 패딩 조정
                        decoration: BoxDecoration(
                          color:
                              selectedIndex == index
                                  ? const Color(0xB20B5B42)
                                  : const Color(0x99D9D9D9),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          BarCategories.categories[index],
                          style: TextStyle(
                            color:
                                selectedIndex == index
                                    ? Colors.white
                                    : const Color(0xFF979797),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        SideScroll(scrollController: _scrollController),
      ],
    );
  }
}
