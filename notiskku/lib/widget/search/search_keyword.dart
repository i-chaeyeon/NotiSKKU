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
    return SizedBox(
      height: 40.h,
      child: Container(
        padding: EdgeInsets.only(left: 12.w, right: 5),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF0B5B42), width: 2.5.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLength: 50,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
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
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap:onClear,
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
      ),
    );
  }
}
