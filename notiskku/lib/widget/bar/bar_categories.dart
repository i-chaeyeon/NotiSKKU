import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/providers/list_notices_provider.dart';
import 'package:notiskku/widget/side_scroll.dart';

class BarCategories extends ConsumerStatefulWidget {
  const BarCategories({super.key});

  @override
  _BarCategoriesState createState() => _BarCategoriesState();
}

class _BarCategoriesState extends ConsumerState<BarCategories> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final currentCategory = ref.watch(barCategoriesProvider);
    final notifier = ref.read(barCategoriesProvider.notifier);

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(Categories.values.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(left: 7.w), //
                  child: GestureDetector(
                    onTap: () {
                      // 선택된 카테고리 변경
                      notifier.state = Categories.values[index];
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
                              currentCategory == Categories.values[index]
                                  ? const Color(0xB20B5B42)
                                  : const Color(0x99D9D9D9),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          _getCategoryLabel(Categories.values[index]),
                          style: TextStyle(
                            color:
                                currentCategory == Categories.values[index]
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

String _getCategoryLabel(Categories category) {
  switch (category) {
    case Categories.all:
      return '전체';
    case Categories.academics:
      return '학사';
    case Categories.admission:
      return '입학';
    case Categories.employment:
      return '취업';
    case Categories.recruitment:
      return '채용/모집';
    case Categories.scholarship:
      return '장학';
    case Categories.eventsAndSeminars:
      return '행사/세미나';
    case Categories.general:
      return '일반';
  }
}
