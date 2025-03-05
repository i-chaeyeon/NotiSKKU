// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:notiskku/models/notice.dart';
// import 'package:notiskku/providers/notice_list_provider.dart';
// import 'package:notiskku/providers/starred_provider.dart';
// import 'package:notiskku/notice_functions/launch_url.dart';

// class ListNotices extends ConsumerWidget {
//   const ListNotices({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final noticesFuture = ref.watch(noticeListProvider);
//     final launchUrlService = LaunchUrlService();

//     return noticesFuture.when(
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (err, stack) => const Center(child: Text('공지사항을 불러오지 못했습니다.')),
//       data: (notices) {
//         if (notices.isEmpty) {
//           return const Center(child: Text('공지사항이 없습니다.'));
//         }

//         return ListView.separated(
//           itemCount: notices.length,
//           separatorBuilder: (_, __) => const Divider(),
//           itemBuilder: (context, index) {
//             final notice = notices[index];
//             final isStarred = ref.watch(starredProvider).any((n) => n.url == notice.url);

//             return ListTile(
//               title: Text(notice.title, style: const TextStyle(fontSize: 15)),
//               subtitle: Text('${notice.date} | 조회수: ${notice.views}'),
//               trailing: GestureDetector(
//                 onTap: () => ref.read(starredProvider.notifier).toggleNotice(notice),
//                 child: Image.asset(
//                   isStarred ? 'assets/images/fullstar_fix.png' : 'assets/images/emptystar_fix.png',
//                   width: 26,
//                   height: 26,
//                 ),
//               ),
//               onTap: () => launchUrlService.launchURL(notice.url),
//             );
//           },
//         );
//       },
//     );
//   }
// }
