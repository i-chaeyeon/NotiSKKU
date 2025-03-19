import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchKeyword extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onClear;

  const SearchKeyword({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF0B5B42), width: 2.5.w),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLength: 50,
              style: TextStyle(fontSize: 18.sp),
              decoration: InputDecoration(
                hintText: '키워드를 입력하세요.',
                hintStyle: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFFD9D9D9),
                ),
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: Icon(
              Icons.search,
              size: 37.w,
              color: const Color(0xFF0B5B42),
            ),
          ),
        ],
      ),
    );
  }
}
