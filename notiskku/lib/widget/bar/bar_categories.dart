import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/providers/notice_list_provider.dart';

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
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      // ✅ 선택된 카테고리 변경
                      notifier.state = index;

                      // ✅ 현재 선택된 학과 가져오기
                      final majorState = ref.read(majorProvider);
                      final majorOrDepartment = majorState.selectedMajors.isNotEmpty
                          ? majorState.selectedMajors[0]
                          : '';

                      // ✅ 공지 리스트를 강제 새로고침 (FutureProvider 다시 실행)
                      ref.invalidate(noticeListProvider);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 4),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? const Color(0xB20B5B42) // 선택된 배경색
                            : const Color(0x99D9D9D9), // 기본 배경색
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: selectedIndex == index
                              ? Colors.white // 선택된 텍스트 색상
                              : Colors.black, // 기본 텍스트 색상
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.arrow_forward_ios, color: Colors.grey),
        ),
      ],
    );
  }
}
