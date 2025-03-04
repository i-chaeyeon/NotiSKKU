import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/major_provider.dart';

class SearchMajor extends ConsumerWidget {
  const SearchMajor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final majorNotifier = ref.read(majorProvider.notifier);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF0B5B42), width: 2.5.w),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLength: 50,
              style: TextStyle(fontSize: 18.sp),
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요.',
                hintStyle: TextStyle(fontSize: 18.sp, color: const Color(0xFFD9D9D9)),
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                majorNotifier.updateSearchText(value);
              },
            ),
          ),
          Icon(Icons.search, size: 37.w, color: const Color(0xFF0B5B42)),
        ],
      ),
    );
  }
}
