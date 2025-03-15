import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/recent_search_provider.dart';

class ListRecentSearch extends ConsumerStatefulWidget {
  const ListRecentSearch({super.key});

  @override
  _ListRecentSearchState createState() => _ListRecentSearchState();
}

class _ListRecentSearchState extends ConsumerState<ListRecentSearch> {
  @override
  Widget build(BuildContext context) {
    final searchedWords = ref.watch(recentSearchProvider);

    return Flexible(
      child: ListView.builder(
        itemCount: searchedWords.length,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemBuilder: (BuildContext context, int index) {
          final reversedIndex = searchedWords.length - 1 - index;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            margin: EdgeInsets.symmetric(vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0x99D9D9D9),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  searchedWords[reversedIndex],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(recentSearchProvider.notifier).deleteWord(searchedWords[reversedIndex]);
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 20.w,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
