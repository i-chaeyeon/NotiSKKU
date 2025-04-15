// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:notiskku/models/keyword.dart';
// import 'package:notiskku/models/notice.dart';
// import 'package:notiskku/providers/list_notices_provider.dart';
// import 'package:notiskku/widget/bar/bar_keywords.dart';
// import 'package:notiskku/widget/list/list_notices.dart';

// class ScreenMainKeyword extends ConsumerWidget {
//   const ScreenMainKeyword({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final allNoticeState = ref.watch(listNoticesProvider);
//     final selectedKeyword = ref.watch(selectedKeywordProvider);
//     final noticeNotifier = ref.read(listNoticesProvider.notifier);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         leading: Padding(
//           padding: EdgeInsets.all(10.0),
//           child: Image.asset('assets/images/greenlogo_fix.png', width: 40.w),
//         ),
//         title: Text(
//           '키워드',
//           style: TextStyle(
//             fontSize: 20.sp,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           const BarKeywords(),
//           SizedBox(height: 10.h),

//           Expanded(
//             child:
//                 allNoticeState.notices.isEmpty
//                     ? const Center(child: CircularProgressIndicator())
//                     : _buildFilteredList(
//                       notices: allNoticeState.notices,
//                       keyword: selectedKeyword,
//                       onLoadMore: () => noticeNotifier.loadMoreNotices(),
//                     ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilteredList({
//     required List<Notice> notices,
//     required Keyword? keyword,
//     required VoidCallback onLoadMore,
//   }) {
//     int loadCount = 0;

//     if (keyword == null) {
//       return const Center(child: Text('키워드를 선택해주세요'));
//     }

//     final filtered =
//         notices
//             .where(
//               (n) =>
//                   n.title.toLowerCase().contains(keyword.keyword.toLowerCase()),
//             )
//             .toList();

//     if (filtered.length < 10 || loadCount > 5) {
//       onLoadMore();
//       loadCount++;
//       return const Center(child: CircularProgressIndicator());
//     }

//     return ListNotices(notices: filtered);
//   }
// }
