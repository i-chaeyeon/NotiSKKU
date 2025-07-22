import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/data/major_data.dart';
import 'package:notiskku/models/major.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/widget/dialog/dialog_limit_major.dart';
import 'package:notiskku/widget/search/search_major.dart';

class ListMajor extends ConsumerWidget {
  const ListMajor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    // 전공 리스트를 검색어 기준으로 필터링하고 가나다순 정렬
       // 1) 검색어로 필터링하고 가나다순 정렬
    final filteredAndSorted = majors
        .where((m) => m.major
            .toLowerCase()
            .contains(userState.currentSearchText.toLowerCase()))
        .toList()
      ..sort((a, b) => a.major.compareTo(b.major));

    // 2) 선택된 학과와 선택되지 않은 학과로 분리
    final selected   = filteredAndSorted
        .where((m) => userState.selectedMajors
            .any((selected) => selected.major == m.major))
        .toList();
    final unselected = filteredAndSorted
        .where((m) => userState.selectedMajors
            .every((selected) => selected.major != m.major))
        .toList();

    // 3) 선택된 학과 먼저, 그 다음 선택되지 않은 학과
    final displayMajors = [...selected, ...unselected];
    
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
          child: const SearchMajor(),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
            itemCount: displayMajors.length,
            itemBuilder: (context, index) {
              final majorObj   = displayMajors[index];
              final major      = majorObj.major;
              final isSelected = userState.selectedMajors
                  .any((m) => m.major == major);

              return GestureDetector(
                onTap: () {
                  if (!isSelected && userState.selectedMajors.length >= 2) {
                    List<String> currentMajors =
                        userState.selectedMajors.map((m) => m.major).toList();
                    _showLimitDialog(context, currentMajors);
                    return;
                  }
                  // displayMajors 내의 객체를 그대로 토글해도 OK
                  userNotifier.toggleMajor(majorObj);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 7.h,
                    horizontal: 10.w,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFD9D9D9), width: 1.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        major,
                        style: TextStyle(
                          fontSize: 19.sp,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w400,
                          color:
                              isSelected
                                  ? const Color(0xFF0B5B42)
                                  : const Color(0xFF979797),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check,
                          color: const Color(0xFF0B5B42),
                          size: 20.w,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showLimitDialog(BuildContext context, List<String> selectedMajors) {
    selectedMajors.sort();

    showDialog(
      context: context,
      builder: (context) => DialogLimitMajor(selectedMajors: selectedMajors),
    );
  }
}
