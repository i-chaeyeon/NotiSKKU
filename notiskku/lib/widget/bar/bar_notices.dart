import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/notice_category_provider.dart';

class BarNotices extends ConsumerWidget {
  const BarNotices({super.key});

  static const categories = ['학교', '단과대학', '학과'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(noticeCategoryProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(categories.length, (index) {
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () => ref.read(noticeCategoryProvider.notifier).state = index,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              categories[index],
              style: TextStyle(
                color: isSelected ? const Color(0xFF0B5B42) : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        );
      }),
    );
  }
}
