import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/widget/toggle/toggle_settings.dart';

class ScreenIntroSelect extends StatefulWidget {
  const ScreenIntroSelect({super.key});

  @override
  State<ScreenIntroSelect> createState() => _ScreenIntroSelectState();
}

class _ScreenIntroSelectState extends State<ScreenIntroSelect> {

  int _currentIndex = 0;
  List<String> selectedMajor = []; // 선택된 전공을 저장할 리스트
  List<String> selectedKeyword = []; // 선택된 키워드를 저장할 리스트

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 80.h), // 반응형 여백

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w), // 반응형 가로 여백
              child: Text(
                '관심 학과와 키워드를 선택해주세요😀\n(학과는 최대 2개까지 가능)',
                textAlign: TextAlign.left, // 텍스트 왼쪽 정렬
                style: TextStyle(
                  color: Colors.black.withOpacity(0.9),
                  fontSize: 14.sp, // 반응형 폰트 크기
                  fontFamily: 'GmarketSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h), // 반응형 간격
          ToggleSettings(
            currentIndex: _currentIndex,
            onIndexChanged: (newIndex) {
              setState(() {
                _currentIndex = newIndex;
              });
            },
          ),
          SizedBox(height: 10.h), // 반응형 간격
          // Expanded(
          //   // 남은 공간 최대한 활용
          //   // child: _currentIndex == 0
          //   //     ? MajorList(
          //   //         selectedMajor: selectedMajor,
          //   //         onSelectedMajorChanged: (majors) {
          //   //           setState(() {
          //   //             selectedMajor = majors; // 선택된 전공 업데이트
          //   //           });
          //   //         },
          //   //       )
          //   //     : KeywordsGrid(
          //   //         selectedKeyword: selectedKeyword,
          //   //         onselectedKeywordChanged: (keywords) {
          //   //           setState(() {
          //   //             selectedKeyword = keywords; // 선택된 키워드 업데이트
          //   //           });
          //   //         },
          //   //       ),
          // ),
          SizedBox(height: 30.h), // 반응형 여백
          // SetupCompleteButton(
          //   selectedMajor: selectedMajor,
          //   selectedKeyword: selectedKeyword,
          // ),
        ],
      ),
    );
  }
}
