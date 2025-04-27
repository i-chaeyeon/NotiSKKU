import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/keyword.dart';
import 'package:notiskku/data/keyword_data.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class GridKeywords extends ConsumerWidget {
  const GridKeywords({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    return Column(
      children: [
        SizedBox(height: 10.h),

        // '선택하지 않음' 버튼 - 로컬 위젯으로 포함
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: _DoNotSelectButton(
            isSelected: userState.doNotSelectKeywords,
            onPressed: () => userNotifier.toggleDoNotSelectKeywords(),
          ),
        ),
        SizedBox(height: 25.h),

        // 키워드 선택 Grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 36.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3열
              childAspectRatio: 86.w / 37.h,
              crossAxisSpacing: 19.w, // 열 간 간격
              mainAxisSpacing: 23.h, // 행 간 간격
            ),
            itemCount: keywords.length,
            itemBuilder: (context, index) {
              final keyword = keywords[index].keyword;
              Keyword matchedKeyword = keywords.firstWhere(
                (k) => k.keyword == keyword,
              );
              final isSelected = userState.selectedKeywords.contains(
                matchedKeyword,
              );
              return GestureDetector(
                onTap: () => userNotifier.toggleKeyword(matchedKeyword),
                child: Container(
                  width: 86.w,
                  height: 37.h,
                  padding: EdgeInsets.symmetric(vertical: 6.h), // 내부 패딩 조정
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? const Color(0xB20B5B42)
                            : const Color(0x99D9D9D9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown, // 글자가 너무 크면 자동으로 축소
                      child: Text(
                        keyword,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19.sp,
                          color:
                              isSelected
                                  ? Colors.white
                                  : const Color(0xFF979797),
                          fontWeight: FontWeight.w700,
                        ),
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

  const _DoNotSelectButton({required this.isSelected, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 282.w,
      height: 36.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor:
              isSelected ? const Color(0xB20B5B42) : const Color(0x99D9D9D9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h), // 버튼 내부 패딩 조절
          child: FittedBox(
            fit: BoxFit.scaleDown, // 글자가 너무 크면 자동으로 축소
            child: Text(
              '선택하지 않음',
              style: TextStyle(
                fontSize: 19.sp,
                color: isSelected ? Colors.white : const Color(0xFF979797),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
