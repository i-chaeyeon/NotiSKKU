import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/data/temp_starred_notices.dart';
import 'package:notiskku/models/keyword.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/widget/side_scroll.dart';

// 선택된 키워드 상태 관리용 Provider
final selectedKeywordProvider = StateProvider<Keyword?>((ref) => null);

class BarKeywords extends ConsumerStatefulWidget {
  const BarKeywords({super.key});

  @override
  ConsumerState<BarKeywords> createState() => _BarKeywordsState();
}

class _BarKeywordsState extends ConsumerState<BarKeywords> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final savedKeywordList = userState.selectedKeywords;
    final selectedKeyword = ref.watch(selectedKeywordProvider);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            child: Text(
              '키워드 별 보기',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(savedKeywordList.length, (index) {
                    final keyword = savedKeywordList[index];
                    final isSelected = keyword == selectedKeyword;

                    return Padding(
                      padding: EdgeInsets.only(left: 7.w),
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .read(userProvider.notifier)
                              .saveTempStarred(tempStarredNotices);
                          ref.read(selectedKeywordProvider.notifier).state =
                              keyword;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xB20B5B42)
                                    : const Color(0x99D9D9D9),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            keyword.keyword,
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : const Color(0xFF979797),
                              fontSize: 14.sp,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
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
        ),
      ],
    );
  }
}
