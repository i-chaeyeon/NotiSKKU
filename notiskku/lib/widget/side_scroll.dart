import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SideScroll extends StatelessWidget {
  final ScrollController scrollController;

  const SideScroll({super.key, required this.scrollController});

  void _scrollRight() {
    scrollController.animateTo(
      scrollController.offset + 100.w,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14.w),
        onPressed: _scrollRight,
      );
  }
}
