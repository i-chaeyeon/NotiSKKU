import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/providers/list_notices_provider.dart';

class BarCategories extends ConsumerWidget {
  const BarCategories({super.key});

  static const categories = [
    '전체', '학사', '입학', '취업', '채용/모집', '장학', '행사/세미나', '일반'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(barCategoriesProvider);
    final notifier = ref.read(barCategoriesProvider.notifier);

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(categories.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(left: 5.w), // 
                  child: GestureDetector(
                    onTap: () {
                      // 선택된 카테고리 변경
                      notifier.state = index;

                      // 현재 선택된 학과 가져오기
                      final majorState = ref.read(majorProvider);
                      final majorOrDepartment = majorState.selectedMajors.isNotEmpty
                          ? majorState.selectedMajors[0]
                          : '';

                      // 공지 리스트 강제 새로고침 (FutureProvider 다시 실행)
                      ref.invalidate(listNoticesProvider);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 3.w), 
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 6.h), // 🔹 패딩 조정
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? const Color(0xB20B5B42) 
                              : const Color(0x99D9D9D9), 
                          borderRadius: BorderRadius.circular(20.r), 
                        ),
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: selectedIndex == index
                                ? Colors.white
                                : Colors.black, 
                            fontSize: 13.sp, 
                            fontWeight:FontWeight.w400, 
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
        Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14.w), // 🔹 반응형 아이콘 크기
        ),
      ],
    );
  }
}
