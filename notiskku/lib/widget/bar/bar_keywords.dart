import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/providers/key_notice_list_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/notice_functions/fetch_notice.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/providers/keyword_provider.dart';
import 'package:notiskku/providers/major_provider.dart';

// class BarKeywords extends ConsumerWidget {
//   const BarKeywords({super.key});

//     void initState() {
//     super.initState();
//     _loadSelectedKeywords();
//     noticesFuture =
//         noticeService.fetchNotices(_getCategoryUrl(0)); // fetchNotices 호출
//   }


//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedIndex = ref.watch(barKeywordsProvider);
//     final notifier = ref.read(barKeywordsProvider.notifier,); // 상태 업데이트를 위한 Notifier

//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   // Navigator.push(
//                   //   context,
//                   //   //MaterialPageRoute(builder: (context) => const StartScreen()),
//                   //   MaterialPageRoute(
//                   //       builder: (context) => const EditKeyword()),
//                   // );
//                 },
//                 child: const Text(
//                   '편집',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: List.generate(
//                       categories
//                           .where((category) => category != '없음') // '없음' 제외
//                           .toList()
//                           .length,
//                       (index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(right: 10),
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedIndex = index;
//                                 noticesFuture = noticeService.fetchNotices(
//                                   _getCategoryUrl(0),
//                                 ); // fetchNotices 호출
//                               });
//                             },
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 33,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color:
//                                     selectedIndex == index
//                                         ? Color(0xB20B5B42)
//                                         : Color(0x99D9D9D9),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Text(
//                                 categories[index],
//                                 style: TextStyle(
//                                   color:
//                                       selectedIndex == index
//                                           ? Colors.white
//                                           : Colors.black,
//                                   fontSize: 15,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ✅ 카테고리별 URL 반환 함수 수정
// String _getCategoryUrl(int index) {
//   return 'https://www.skku.edu/skku/campus/skk_comm/notice01.do';
// }