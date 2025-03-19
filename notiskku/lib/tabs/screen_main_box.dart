import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/notice_functions/launch_url.dart';
import 'package:notiskku/providers/starred_provider.dart';

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
          if (!editMode)
            // 편집 모드 아닐 때: "편집" 표시
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    editMode = true;
                  });
                },
                child: const Text(
                  '편집',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          else
            // 편집 모드일 때: "전체선택" 표시
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    // 이미 전부 선택된 경우 해제, 아니면 전부 선택
                    if (_selectedNotices.length == starredNotices.length) {
                      _selectedNotices.clear();
                    } else {
                      _selectedNotices.clear();
                      _selectedNotices.addAll(starredNotices);
                    }
                  });
                },
                child: const Text(
                  '전체선택',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
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
            child: starredNotices.isEmpty
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
                      // 가장 최근에 추가된 항목이 위로 오도록 뒤집어 보여주는 로직
                      final reversedIndex = starredNotices.length - 1 - index;
                      final starredNotice = starredNotices[reversedIndex];

                      final bool isSelected =
                          _selectedNotices.contains(starredNotice);

                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              starredNotice.title,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              '${starredNotice.date} | 조회수: ${starredNotice.views}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            // 편집 모드일 때와 아닐 때 trailing 아이콘이 달라짐
                            trailing: editMode
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // 선택/해제 토글
                                        if (isSelected) {
                                          _selectedNotices.remove(starredNotice);
                                        } else {
                                          _selectedNotices.add(starredNotice);
                                        }
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
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      // 별표 탭 시 즐겨찾기 해제(제거)
                                      ref
                                          .read(starredProvider.notifier)
                                          .toggleNotice(starredNotice);
                                    },
                                    child: Image.asset(
                                      'assets/images/fullstar_fix.png',
                                      width: 26,
                                      height: 26,
                                    ),
                                  ),
                            onTap: () async {
                              // 편집 모드가 아닐 때만 실제 링크로 이동
                              if (!editMode) {
                                await launchUrlService
                                    .launchURL(starredNotice.url);
                              } else {
                                // 편집 모드에서는 onTap을 누르면 체크만 토글
                                setState(() {
                                  if (isSelected) {
                                    _selectedNotices.remove(starredNotice);
                                  } else {
                                    _selectedNotices.add(starredNotice);
                                  }
                                });
                              }
                            },
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ],
                      );
                    },
                  ),
          ),

          // 편집 모드일 때만 아래쪽에 "삭제" 버튼 표시
              if (editMode)
                Padding(
                  padding: EdgeInsets.only(bottom: 40), // 반응형 하단 여백
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9, // 화면 너비의 90% 정도로 설정
                    child: ElevatedButton(
                      // 아무것도 선택 안 했으면 비활성화
                      onPressed: _selectedNotices.isEmpty
                          ? null
                          : () {
                              final notifier = ref.read(starredProvider.notifier);
                              for (final notice in _selectedNotices) {
                                notifier.toggleNotice(notice);
                              }
                              setState(() {
                                _selectedNotices.clear();
                                editMode = false;
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(300, 60), // 가로 300, 세로 60으로 지정(원하는 값으로 조절)
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
