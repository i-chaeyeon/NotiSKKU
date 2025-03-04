import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/data/major_data.dart';

class ListMajor extends ConsumerWidget {
  const ListMajor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final majorState = ref.watch(majorProvider);
    final majorNotifier = ref.read(majorProvider.notifier);

    final filteredMajors = majorState.majors.where((major) {
      return major.toLowerCase().contains(majorState.searchText.toLowerCase());
    }).toList();

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
      itemCount: filteredMajors.length,
      itemBuilder: (context, index) {
        final major = filteredMajors[index];
        final isSelected = majorState.selectedMajors.contains(major);

        return GestureDetector(
          onTap: () {
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
                  const Icon(Icons.check, color: Color(0xFF0B5B42)),
              ],
            ),
          ),
        );
      },
    );
  }
}
