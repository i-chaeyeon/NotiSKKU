import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/widget/side_scroll.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarKeywords extends StatefulWidget {
  final Function(String) onKeywordSelected;

  const BarKeywords({Key? key, required this.onKeywordSelected})
    : super(key: key);

  @override
  _BarKeywordsState createState() => _BarKeywordsState();
}

class _BarKeywordsState extends State<BarKeywords> {
  final ScrollController _scrollController = ScrollController();
  int selectedKeywordIndex = 0;
  List<String> keywords = [];

  @override
  void initState() {
    super.initState();
    _loadKeywords();
  }

  // SharedPreferences에서 키워드 불러오기
  Future<void> _loadKeywords() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      keywords = prefs.getStringList('selectedKeywords') ?? ['Default Keyword'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            child: Text(
              '키워드 별 보기',
              style: TextStyle(
                fontSize: 16.sp,
                // fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
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
                  children: List.generate(
                    keywords
                        .where((category) => category != '없음')
                        .toList()
                        .length,
                    (index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 7.w), // 간격 줄이기
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedKeywordIndex = index;
                            });
                            widget.onKeywordSelected(keywords[index]);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  selectedKeywordIndex == index
                                      ? const Color(0xB20B5B42)
                                      : const Color(0x99D9D9D9),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              keywords[index],
                              style: TextStyle(
                                color:
                                    selectedKeywordIndex == index
                                        ? Colors.white
                                        : const Color(0xFF979797),
                                fontSize: 14.sp,
                                fontWeight:
                                    selectedKeywordIndex == index
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
