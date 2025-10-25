import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogLimitMajor extends StatelessWidget {
  final List<String> selectedMajors;

  const DialogLimitMajor({super.key, required this.selectedMajors});

  // 한글 줄바꿈 개선 함수
  String applyWordBreakFix(String text) {
    final RegExp emoji = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
    );
    String fullText = '';
    List<String> words = text.split(' ');
    for (var i = 0; i < words.length; i++) {
      fullText +=
          emoji.hasMatch(words[i])
              ? words[i]
              : words[i].replaceAllMapped(
                RegExp(r'(\S)(?=\S)'),
                (m) => '${m[1]}\u200D',
              );
      if (i < words.length - 1) fullText += ' ';
    }
    return fullText;
  }

  @override
  Widget build(BuildContext context) {
    final String fixedInstruction = applyWordBreakFix(
      '전공은 최대 두 개까지 선택할 수 있습니다.',
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      backgroundColor: Colors.white,
      title: Text(
        '⚠️ 전공 선택 제한',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0B5B42),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text('전공은 최대 두 개까지 선택할 수 있습니다.', style: TextStyle(fontSize: 14.sp)),
          Text(fixedInstruction, style: TextStyle(fontSize: 12.sp)),
          SizedBox(height: 10.h),
          Text(
            "선택한 전공:",
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
          ),
          Text(selectedMajors.join('\n'), style: TextStyle(fontSize: 13.sp)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            '확인',
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF0B5B42)),
          ),
        ),
      ],
    );
  }
}
