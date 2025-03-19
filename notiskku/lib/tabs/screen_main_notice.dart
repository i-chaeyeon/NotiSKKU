import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/notice.dart';
// import 'package:notiskku/notice_functions/fetch_notice.dart';
// import 'package:notiskku/notice_functions/launch_url.dart';
import 'package:notiskku/providers/starred_provider.dart';
import 'package:notiskku/providers/major_provider.dart';

class ScreenMainNotice extends ConsumerStatefulWidget {
  const ScreenMainNotice({Key? key}) : super(key: key);

  @override
  _ScreenMainNoticeState createState() => _ScreenMainNoticeState();
}

class _ScreenMainNoticeState extends ConsumerState<ScreenMainNotice> {
  int selectedCategoryIndex = 0;
  final List<String> categories0 = ['학교', '단과대학', '학과'];
  int selectedIndex = 0;
  final List<String> categories = [
    '전체',
    '학사',
    '입학',
    '취업',
    '채용/모집',
    '장학',
    '행사/세미나',
    '일반'
  ];
  List<bool> isStarred = [];

  // 실제 fetchNotices 대신, 더미 공지를 불러오는 Future
  Future<List<Notice>>? noticesFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // noticesFuture가 null인 경우에만 초기 값 세팅
    if (noticesFuture == null) {
      // 그냥 더미 데이터 세팅
      noticesFuture = _fetchDummyNotices();
    }
  }

  // 더미 Notice 리스트를 반환하는 함수
  Future<List<Notice>> _fetchDummyNotices() async {
    // 예: 1초 정도 대기 후(옵션) 더미 데이터를 준다고 가정
    await Future.delayed(const Duration(seconds: 1));

    return [
      Notice(
        title: '더미 공지사항 1',
        date: '2025-03-17',
        views: '123',
        url: 'https://example.com/notice1',
      ),
      Notice(
        title: '더미 공지사항 2',
        date: '2025-03-16',
        views: '456',
        url: 'https://example.com/notice2',
      ),
      Notice(
        title: '더미 공지사항 3',
        date: '2025-03-15',
        views: '789',
        url: 'https://example.com/notice3',
      ),
    ];
  }

  // 카테고리나 학과를 바꿔도 동일한 더미 데이터를 표시하고 싶다면, 아래 메소드에서도 fetchDummyNotices()를 호출
  void _updateNotices() {
    setState(() {
      noticesFuture = _fetchDummyNotices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final majorState = ref.watch(majorProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset('assets/images/greenlogo_fix.png', width: 40),
        ),
        title: majorState.selectedMajors.isNotEmpty
            ? Text(
                majorState.selectedMajors.join(', '),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              )
            : const Text(
                '학과를 선택하세요',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 상단 바 (카테고리, 학과 선택 부분)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // 학교 / 단과대학 / 학과
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(categories0.length * 2 - 1, (index) {
                    if (index % 2 == 1) {
                      return Container(
                        width: 1.5,
                        height: 20,
                        color: Colors.grey[600],
                      );
                    } else {
                      int categoryIndex = index ~/ 2;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategoryIndex = categoryIndex;
                              _updateNotices();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: selectedCategoryIndex == categoryIndex
                                  ? const Color(0xFFE8F5E9)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(
                              child: Text(
                                categories0[categoryIndex],
                                style: TextStyle(
                                  color: selectedCategoryIndex == categoryIndex
                                      ? const Color(0xFF0B5B42)
                                      : Colors.grey,
                                  fontWeight: selectedCategoryIndex == categoryIndex
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
                ),
                const SizedBox(height: 10),
                // 카테고리 스크롤
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(categories.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                    _updateNotices();
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 33,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedIndex == index
                                        ? const Color(0xB20B5B42)
                                        : const Color(0x99D9D9D9),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    categories[index],
                                    style: TextStyle(
                                      color: selectedIndex == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),

          // 실제 공지사항 표시
          Expanded(
            child: FutureBuilder<List<Notice>>(
              future: noticesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // 오류 처리
                  return Center(child: Text('Failed to load notices.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No notices available'));
                } else {
                  final notices = snapshot.data!;
                  final starredList = ref.watch(starredProvider);

                  return ListView.builder(
                    itemCount: notices.length,
                    itemBuilder: (context, index) {
                      final notice = notices[index];
                      final isStarred = starredList.any((n) => n.url == notice.url);

                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              notice.title,
                              style: const TextStyle(fontSize: 15, color: Colors.black),
                            ),
                            subtitle: Text(
                              '${notice.date} | 조회수: ${notice.views}',
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                ref.read(starredProvider.notifier).toggleNotice(notice);
                              },
                              child: Image.asset(
                                isStarred
                                    ? 'assets/images/fullstar_fix.png'
                                    : 'assets/images/emptystar_fix.png',
                                width: 26,
                                height: 26,
                              ),
                            ),
                            onTap: () {
                              // 더미 URL이므로 실제 웹뷰/브라우저 오픈은 생략
                              // 혹은 실제로 launch 하시려면 launchUrlService.launchURL(...) 호출
                              debugPrint('Notice tapped: ${notice.title}');
                            },
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
