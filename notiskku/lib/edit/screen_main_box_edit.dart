import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/notice_functions/launch_url.dart';
import 'package:notiskku/providers/starred_provider.dart';

class ScreenMainBoxEdit extends ConsumerStatefulWidget {
  const ScreenMainBoxEdit({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenMainBoxEditState();
  }
}

class _ScreenMainBoxEditState extends ConsumerState<ScreenMainBoxEdit> {
  // 편집 모드에서 선택된 공지를 담을 집합
  final Set<Notice> _selectedNotices = {};

  @override
  Widget build(BuildContext context) {
    final starredNotices = ref.watch(starredProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // 편집 화면 닫기
          },
          child: const Center(
            child: Text(
              '취소',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ),
        title: const Text(
          '공지 편집',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (_selectedNotices.length == starredNotices.length) {
                  _selectedNotices.clear();
                } else {
                  _selectedNotices
                    ..clear()
                    ..addAll(starredNotices);
                }
              });
            },
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                '전체선택',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child:
                starredNotices.isEmpty
                    ? const Center(
                      child: Text(
                        '저장된 공지가 없습니다',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: starredNotices.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (BuildContext context, int index) {
                        final reversedIndex = starredNotices.length - 1 - index;
                        final notice = starredNotices[reversedIndex];
                        final bool isSelected = _selectedNotices.contains(
                          notice,
                        );

                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                notice.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                '${notice.date} | 조회수: ${notice.views}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSelected
                                        ? _selectedNotices.remove(notice)
                                        : _selectedNotices.add(notice);
                                  });
                                },
                                child: Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color:
                                      isSelected ? Colors.green : Colors.grey,
                                  size: 26,
                                ),
                              ),
                            ),
                            const Divider(color: Colors.grey, thickness: 1),
                          ],
                        );
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                onPressed:
                    _selectedNotices.isEmpty
                        ? null
                        : () {
                          final notifier = ref.read(starredProvider.notifier);
                          for (final notice in _selectedNotices) {
                            notifier.toggleNotice(notice);
                          }
                          Navigator.pop(context); // 편집 화면 닫기
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(300, 60),
                ),
                child: const Text(
                  '삭제',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
