import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/keyword_provider.dart';
import 'package:notiskku/data/keyword_data.dart';
// import 'package:notiskku/widgets/do_not_select.dart';

class GridKeywords extends ConsumerWidget {
  const GridKeywords({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keywordState = ref.watch(keywordProvider);
    final keywordNotifier = ref.read(keywordProvider.notifier);

    double buttonWidth = (1.sw - 80.w) / 3;
    double buttonHeight = buttonWidth * (37 / 86);

    return Column(
      children: [
        // DoNotSelect(
        //   isSelected: keywordState.isDoNotSelect,
        //   onPressed: keywordNotifier.toggleDoNotSelect,
        // ),
        SizedBox(height: 10.h),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: buttonWidth / buttonHeight,
              crossAxisSpacing: 19.w,
              mainAxisSpacing: 30.h,
            ),
            itemCount: keywords.length,
            itemBuilder: (context, index) {
              final keyword = keywords[index].keyword;
              final isSelected = keywordState.selectedKeywords.contains(keyword);

              return GestureDetector(
                onTap: () => keywordNotifier.toggleKeyword(keyword),
                child: Container(
                  width: buttonWidth,
                  height: buttonHeight,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xB20B5B42) : const Color(0x99D9D9D9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: Text(
                      keyword,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isSelected ? Colors.white : const Color(0xFF979797),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
