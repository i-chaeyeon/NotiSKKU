import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/bar_providers.dart';

class BarNotices extends ConsumerWidget {
  const BarNotices({super.key});

  static const categories = ['학교', '단과대학', '학과'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(barNoticesProvider);
    final notifier = ref.read(barNoticesProvider.notifier); // 상태 업데이트를 위한 Notifier

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(categories.length * 2 - 1, (index) {
        // 홀수 인덱스에는 구분선을, 짝수 인덱스에는 카테고리를 표시
        if (index % 2 == 1) {
          return Container(
            width: 1.5, // 구분선의 너비
            height: 20, // 구분선의 높이
            color: Colors.grey[600], // 구분선 색상
          );
        } else {
          int categoryIndex = index ~/ 2;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                notifier.state = categoryIndex; // 상태 변경
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: selectedIndex == categoryIndex
                      ? const Color(0xFFE8F5E9)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Center(
                  child: Text(
                    categories[categoryIndex],
                    style: TextStyle(
                      color: selectedIndex == categoryIndex
                          ? const Color(0xFF0B5B42)
                          : Colors.grey,
                      fontWeight: selectedIndex == categoryIndex
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
