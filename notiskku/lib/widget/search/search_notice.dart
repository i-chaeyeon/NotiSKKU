import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/recent_search_provider.dart';

class SearchNotice extends ConsumerStatefulWidget {
  const SearchNotice({super.key, required this.onSearchChanged});

  final ValueChanged<String> onSearchChanged;

  @override
  _SearchNoticeState createState() {
    return _SearchNoticeState();
  }
}

class _SearchNoticeState extends ConsumerState<SearchNotice> {
  final TextEditingController _titleController = TextEditingController();
  bool isSearchEnabled = false; // 검색 버튼 활성화 여부

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    setState(() {
      isSearchEnabled = value.isNotEmpty;
    });
    widget.onSearchChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.only(left: 12.w, right: 5.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF0B5B42), width: 2.5.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _titleController,
                maxLength: 50,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintText: '검색어를 입력하세요.',
                  hintStyle: TextStyle(
                    fontSize: 18.sp,
                    color: const Color(0xFFD9D9D9),
                  ),
                  counterText: '',
                  border: InputBorder.none,
                ),
                onChanged: _onTextChanged, // 텍스트 변경 감지
                onSubmitted: (value) {
                  if (isSearchEnabled) {
                    ref.read(recentSearchProvider.notifier).searchWord(value);
                  }
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      _titleController.clear();
                      _onTextChanged('');
                    },
                    icon: const Icon(Icons.cancel, color: Color(0xff979797)),
                    padding: EdgeInsets.zero,
                    splashRadius: 10.w, // 터치 효과 반경 설정
                  ),
                ),
                SizedBox(width: 3.w),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap:
                        isSearchEnabled
                            ? () {
                              FocusScope.of(context).unfocus();
                              ref
                                  .read(recentSearchProvider.notifier)
                                  .searchWord(_titleController.text);
                            }
                            : null, // 입력된 내용 없을 경우 비활성화 상태 적용
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Image.asset(
                        'assets/images/green_search.png',
                        width: 37.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  //   IconButton(
                  //   onPressed:
                  //       isSearchEnabled
                  //           ? () {
                  //             FocusScope.of(context).unfocus();
                  //             ref
                  //                 .read(recentSearchProvider.notifier)
                  //                 .searchWord(_titleController.text);
                  //           }
                  //           : null, // 입력된 내용 없을 경우 비활성화 상태 적용
                  //   icon: Icon(
                  //     Icons.search,
                  //     size: 37.w,
                  //     color: const Color(0xFF0B5B42),
                  //   ),
                  //   padding: EdgeInsets.zero,
                  //   splashRadius: 25.w,
                  // ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
