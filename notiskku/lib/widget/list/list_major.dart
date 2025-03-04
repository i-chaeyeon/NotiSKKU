import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/widget/search/search_major.dart';

class ListMajor extends ConsumerWidget {
  const ListMajor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final majorState = ref.watch(majorProvider);
    final majorNotifier = ref.read(majorProvider.notifier);

    // 검색어 기반 필터링
    final filteredMajors = majorState.majors.where((major) {
      return major.toLowerCase().contains(majorState.searchText.toLowerCase());
    }).toList();

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
              final major = filteredMajors[index];
              final isSelected = majorState.selectedMajors.contains(major);

              return GestureDetector(
                onTap: () {
                  if (!isSelected && majorState.selectedMajors.length >= 2) {
                    // 선택 제한 초과 경고 표시
                    _showLimitDialog(context, majorState.selectedMajors);
                    return;
                  }
                  majorNotifier.toggleMajor(major);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFFD9D9D9), width: 2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        major,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                          color: isSelected ? const Color(0xFF0B5B42) : const Color(0xFF979797),
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check, color: const Color(0xFF0B5B42), size: 20.w),
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


// 추후 위젯 분리 고려 
  void _showLimitDialog(BuildContext context, List<String> selectedMajors) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          backgroundColor: Colors.white,
          title: Text(
            '⚠️ 전공 선택 제한',
            style: TextStyle(
              // fontSize: 18.sp,
              color: const Color(0xFF0B5B42),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('전공은 최대 두 개까지 선택할 수 있습니다.', style: TextStyle(fontSize: 14.sp)),
              SizedBox(height: 10.h),
              Text(
                "선택한 전공:\n${selectedMajors.join('\n')}",
                style: TextStyle(fontSize: 13.sp),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인', style: TextStyle(fontSize: 16.sp, color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
