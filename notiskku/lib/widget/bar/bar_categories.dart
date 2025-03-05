// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:notiskku/providers/notice_category_provider.dart';

// class BarCategories extends ConsumerWidget {
//   const BarCategories({super.key});

//   static const categories = [
//     '전체', '학사', '입학', '취업', '채용/모집', '장학', '행사/세미나', '일반'
//   ];

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedIndex = ref.watch(noticeSubCategoryProvider);

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(categories.length, (index) {
//           final isSelected = selectedIndex == index;

//           return GestureDetector(
//             onTap: () => ref.read(noticeSubCategoryProvider.notifier).state = index,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 4),
//               margin: const EdgeInsets.only(right: 10),
//               decoration: BoxDecoration(
//                 color: isSelected ? const Color(0xB20B5B42) : const Color(0x99D9D9D9),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Text(
//                 categories[index],
//                 style: TextStyle(
//                   color: isSelected ? Colors.white : Colors.black,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
