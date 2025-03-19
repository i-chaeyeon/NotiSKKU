import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/notice_functions/launch_url.dart';
import 'package:notiskku/providers/starred_provider.dart';
import 'package:notiskku/edit/screen_main_box_edit.dart';

class ScreenMainBox extends ConsumerStatefulWidget {
  const ScreenMainBox({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenMainBoxState();
  }
}

class _ScreenMainBoxState extends ConsumerState<ScreenMainBox> {
  bool editMode = false;             // 편집 모드 여부
  final LaunchUrlService launchUrlService = LaunchUrlService();

  // 편집 모드에서 선택된 공지를 담을 집합
  final Set<Notice> _selectedNotices = {};

  @override
  Widget build(BuildContext context) {
    final starredNotices = ref.watch(starredProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // 편집 모드 여부에 따라 leading 위젯 변경
        leading: editMode
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      // 편집 모드 종료 & 선택 해제
                      editMode = false;
                      _selectedNotices.clear();
                    });
                  },
                  child: const Center(
                    child: Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset('assets/images/greenlogo_fix.png', width: 40),
              ),
        title: const Text(
          '공지보관함',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        // 우측 상단 버튼
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScreenMainBoxEdit(),
                  ),
                );
              },
              child: const Text(
                '편집',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
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
                          final reversedIndex =
                              starredNotices.length - 1 - index;
                          final starredNotice = starredNotices[reversedIndex];

                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  starredNotice.title, // 공지 제목 표시
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                onTap: () async {
                                  await launchUrlService.launchURL(
                                    starredNotice.url,
                                  );
                                },
                              ),
                              const Divider(color: Colors.grey, thickness: 1),
                            ],
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
