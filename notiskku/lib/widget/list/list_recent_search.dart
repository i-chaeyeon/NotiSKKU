import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/tabs/screen_main_search.dart';
import 'package:notiskku/widget/list/list_search_results.dart';

class ListRecentSearch extends ConsumerStatefulWidget {
  final void Function(String searchText)? onTapRecentSearch;
  const ListRecentSearch({super.key, this.onTapRecentSearch});

  @override
  ListRecentSearchState createState() => ListRecentSearchState();
}

class ListRecentSearchState extends ConsumerState<ListRecentSearch> {
  @override
  Widget build(BuildContext context) {
    final searchedTexts = ref.watch(userProvider).recentSearchedText;

    return Flexible(
      child: ListView.builder(
        itemCount: searchedTexts.length,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemBuilder: (BuildContext context, int index) {
          final reversedIndex = searchedTexts.length - 1 - index;
          return GestureDetector(
            onTap: () {
              // 여기에 원하는 동작 작성
              widget.onTapRecentSearch?.call(searchedTexts[reversedIndex]);
            },
            child: Container(
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
                    searchedTexts[reversedIndex],
                    style: TextStyle(color: Colors.black, fontSize: 15.sp),
                  ),
                  GestureDetector(
                    onTap: () {
                      ref
                          .read(userProvider.notifier)
                          .deleteRecentSearch(searchedTexts[reversedIndex]);
                    },
                    child: Icon(Icons.close, color: Colors.black, size: 20.w),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
