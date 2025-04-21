import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class SearchNotice extends ConsumerStatefulWidget {
  final Function(String, bool) onSearch; //검색 실행 후 상태를 부모위젯젯에게 전달

  const SearchNotice({super.key, required this.onSearch});

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

  // 사용자가 검색어를 입력할 때 실행되는 함수
  void _onTextChanged(String value) {
    setState(() {
      isSearchEnabled = value.isNotEmpty;
    });
    // 검색창이 비어있으면 `isSearched = false`로 값 변경
    if (value.isEmpty) {
      widget.onSearch('', false);
    }
  }

  // 검색을 실행하는 함수
  void _onSearch() {
    if (!isSearchEnabled) return;
    final searchText = _titleController.text.trim();
    if (searchText.isNotEmpty) {
      ref.read(userProvider.notifier).addRecentSearch(searchText);
      widget.onSearch(searchText, true); // 검색 실행 상태 전달 !!
      FocusScope.of(context).unfocus(); // 키보드 닫기
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
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
                onChanged: _onTextChanged, // 입력 시 검색 버튼 활성화
                onSubmitted: (value) => _onSearch(), // Enter 키 입력 시 검색 실행
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
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: _onSearch, // 검색 버튼 클릭 시 실행
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Image.asset(
                        'assets/images/green_search.png',
                        width: 37.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
