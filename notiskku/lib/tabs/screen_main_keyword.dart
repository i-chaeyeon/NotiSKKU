import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/list_key_notices_provider.dart';
import 'package:notiskku/widget/bar/bar_keywords.dart';
import 'package:notiskku/widget/list/list_notices.dart';

class ScreenMainKeyword extends ConsumerWidget {
  const ScreenMainKeyword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeAsync = ref.watch(ListKeyNoticesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(10.0),
          child: Image.asset('assets/images/greenlogo_fix.png', width: 40),
        ),
        title: Text(
          '키워드',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 키워드 선택 바
          BarKeywords(
            onKeywordSelected: (selectedKeyword) {
              ref.invalidate(ListKeyNoticesProvider); // 선택 시 새로고침
            },
          ),
          Expanded(
            child: noticeAsync.when(
              data: (notices) => ListNotices(notices: notices),
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stack) =>
                      const Center(child: Text('Failed to load notices')),
            ),
          ),
        ],
      ),
    );
  }
}
