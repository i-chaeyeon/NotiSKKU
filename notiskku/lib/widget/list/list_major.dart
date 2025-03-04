import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:notiskku_demo/data/major_data.dart';
// import 'package:notiskku_demo/services/preference_services.dart';
// import 'package:notiskku_demo/widgets/search_major.dart';

class ListMajor extends StatefulWidget {
  const ListMajor({
    super.key,
    required this.selectedMajor,
    required this.onSelectedMajorChanged,
  });

  final List<String> selectedMajor;
  final Function(List<String>) onSelectedMajorChanged;

  @override
  State<MajorList> createState() => _MajorListState();
}

class _MajorListState extends State<MajorList> {
  String searchText = '';
  List<String> majors = major.map((major) => major.major).toList();

  @override
  void initState() {
    super.initState();
    loadSelectedMajors(); // 전공 목록 불러오기
  }

  // 저장된 전공 목록 불러오는 메서드
  Future<void> loadSelectedMajors() async {
    List<String>? loadedMajors = await getSelectedMajors();
    if (loadedMajors != null) {
      setState(() {
        widget.selectedMajor.clear(); // 기존 선택된 전공 목록 초기화
        widget.selectedMajor.addAll(loadedMajors); // 불러온 전공 목록 추가
      });
    }
  }

  // 전공 목록을 저장하는 메서드
  Future<void> saveSelectedMajorsToPrefs() async {
    await saveSelectedMajors(widget.selectedMajor);
  }

  @override
  Widget build(BuildContext context) {
    majors.sort((a, b) => a.compareTo(b));

    return Column(
      children: [
        SearchMajor(
          onSearchChanged: (newText) {
            setState(() {
              searchText = newText;
            });
          },
        ),
        SizedBox(height: 10.h), // 반응형 간격 추가
        Expanded(
          child: ListView.builder(
            itemCount: majors.length,
            itemBuilder: (BuildContext context, int index) {
              if (searchText.isNotEmpty &&
                  !majors[index]
                      .toLowerCase()
                      .contains(searchText.toLowerCase())) {
                return const SizedBox.shrink();
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (widget.selectedMajor.contains(majors[index])) {
                      widget.selectedMajor.remove(majors[index]);
                    } else if (widget.selectedMajor.length < 2) {
                      widget.selectedMajor.add(majors[index]);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r), // 반응형 모서리 둥글기
                            ),
                            backgroundColor: Colors.white,
                            title: Text(
                              '전공 선택 제한',
                              style: TextStyle(
                                fontSize: 18.sp, // 반응형 폰트 크기
                                color: const Color(0xFF0B5B42),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "전공은 최대 두 개까지 선택할 수 있습니다.",
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  "선택한 전공: \n ${widget.selectedMajor.join('\n ')}",
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  '확인',
                                  style: TextStyle(fontSize: 16.sp, color: Colors.black),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    widget.onSelectedMajorChanged(widget.selectedMajor);
                    saveSelectedMajorsToPrefs(); // 전공 목록 저장
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.w), // 반응형 가로 여백
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w, // 반응형 내부 패딩
                    vertical: 15.h, // 반응형 내부 패딩
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFD9D9D9),
                        width: 2,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        majors[index],
                        style: TextStyle(
                          fontSize: 17.5.sp, // 반응형 폰트 크기
                          fontWeight:
                              widget.selectedMajor.contains(majors[index])
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                          color: widget.selectedMajor.contains(majors[index])
                              ? const Color(0xFF0B5B42)
                              : const Color(0xFF979797),
                        ),
                      ),
                      if (widget.selectedMajor.contains(majors[index]))
                        Icon(Icons.check, color: const Color(0xFF0B5B42), size: 20.w), // 반응형 아이콘 크기
                    ],
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
