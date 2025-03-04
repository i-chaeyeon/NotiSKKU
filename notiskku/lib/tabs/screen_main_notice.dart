import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/major_provider.dart';
import 'package:notiskku/widget/bar/bar_categories.dart';
import 'package:notiskku/widget/bar/bar_notices.dart';
import 'package:notiskku/widget/list/list_notices.dart';


class ScreenMainNotice extends ConsumerWidget {
  const ScreenMainNotice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMajors = ref.watch(majorProvider).selectedMajors;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset('assets/images/greenlogo_fix.png', width: 40),
        ),
        title: Text(
          selectedMajors.isNotEmpty ? selectedMajors.join(', ') : '학과를 선택하세요',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: [
          //IconButton(
          //  icon: Image.asset('assets/images/search_fix.png', width: 30),
          //  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchNoticeScreen())),
          //),
        ],
      ),
      body: const Column(
        children: [
          BarNotices(),
          BarCategories(),
          Expanded(child: ListNotices()),
        ],
      ),
    );
  }
}
