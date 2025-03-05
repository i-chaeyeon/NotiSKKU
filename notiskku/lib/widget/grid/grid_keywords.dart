import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/keyword_provider.dart';
import 'package:notiskku/data/keyword_data.dart';

class GridKeywords extends ConsumerWidget {
  const GridKeywords({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keywordState = ref.watch(keywordProvider);
    final keywordNotifier = ref.read(keywordProvider.notifier);

    // 반응형 버튼 크기 계산
    final buttonWidth = (1.sw - 80.w) / 3;
    final buttonHeight = buttonWidth * (37 / 86);

    return Column(
      children: [
        SizedBox(height: 10.h),

        // '선택하지 않음' 버튼 - 로컬 위젯으로 포함
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: _DoNotSelectButton(
            isSelected: keywordState.isDoNotSelect,
            onPressed: () => keywordNotifier.toggleDoNotSelect(),
          ),
        ),

        SizedBox(height: 10.h),

        // 키워드 선택 Grid
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

// GridKeywords 안에만 쓰는 private 위젯으로 정의
class _DoNotSelectButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onPressed;

  const _DoNotSelectButton({
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = (1.sw - 80.w) / 3;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: isSelected ? const Color(0xB20B5B42) : const Color(0x99D9D9D9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        child: Text(
          '선택하지 않음',
          style: TextStyle(
            fontSize: buttonWidth * 0.16,
            color: isSelected ? Colors.white : const Color(0xFF979797),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
