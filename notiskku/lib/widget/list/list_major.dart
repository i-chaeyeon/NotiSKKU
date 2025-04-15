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
    final filteredMajors =
        majors
            .where(
              (major) => major.major.toLowerCase().contains(
                userState.currentSearchText.toLowerCase(),
              ),
            )
            .toList()
          ..sort((a, b) => a.major.compareTo(b.major));

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
          child: const SearchMajor(),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
            itemCount: filteredMajors.length,
            itemBuilder: (context, index) {
              final major = filteredMajors[index].major;
              final isSelected = userState.selectedMajors
                  .map((m) => m.major)
                  .contains(filteredMajors[index].major);

              return GestureDetector(
                onTap: () {
                  if (!isSelected && userState.selectedMajors.length >= 2) {
                    List<String> currentMajors =
                        userState.selectedMajors.map((m) => m.major).toList();
                    _showLimitDialog(context, currentMajors);
                    return;
                  }
                  Major matchedMajor = majors.firstWhere(
                    (m) => m.major == major,
                  );
                  userNotifier.toggleMajor(matchedMajor);
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
