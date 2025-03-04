import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToggleSettings extends StatefulWidget {
  const ToggleSettings({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  @override
  State<ToggleSettings> createState() => _ToggleSettingsState();
}

class _ToggleSettingsState extends State<ToggleSettings> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(0, "학과", 0.4.sw), // 화면 너비의 40%로 버튼 크기 설정
        SizedBox(width: 12.w), // 버튼 사이 간격을 반응형으로 조정
        _buildButton(1, "키워드", 0.4.sw), // 화면 너비의 40%로 버튼 크기 설정
      ],
    );
  }

  Widget _buildButton(int index, String text, double buttonWidth) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        widget.onIndexChanged(index);
      },
      child: Container(
        width: buttonWidth, // 반응형 너비 설정
        padding: EdgeInsets.symmetric(vertical: 10.h), // 반응형 패딩
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF0B5B42) : const Color(0xFF979797),
              width: isSelected ? 2.5.h : 1.h, // 반응형 테두리 두께
            ),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20.sp, // 반응형 폰트 크기
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w300,
              color: isSelected ? const Color(0xFF0B5B42) : const Color(0xFF979797),
            ),
          ),
        ),
      ),
    );
  }
}
