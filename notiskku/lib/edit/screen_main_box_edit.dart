import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class ScreenMainBoxEdit extends ConsumerStatefulWidget {
  const ScreenMainBoxEdit({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenMainBoxEditState();
  }
}

class _ScreenMainBoxEditState extends ConsumerState<ScreenMainBoxEdit> {
  // 편집 모드에서 선택된 공지를 담을 집합
  final Set<String> _selectedHashes = {};

  @override
  Widget build(BuildContext context) {
    final starredHashes = ref.watch(userProvider).starredNotices;
    final bool isAllSelected =
        _selectedHashes.length == starredHashes.length &&
        starredHashes.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // 편집 화면 닫기
          },
          child: Center(
            child: Text(
              '취소',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: Text(
          '공지 편집',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (_selectedHashes.length == starredHashes.length) {
                  _selectedHashes.clear();
                } else {
                  _selectedHashes
                    ..clear()
                    ..addAll(starredHashes);
                }
              });
            },
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                '전체선택',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color:
                      isAllSelected
                          ? const Color(0xFF0B5B42)
                          : const Color(0xFF979797),
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
            child:
                starredHashes.isEmpty
                    ? Center(
                      child: Text(
                        '저장된 공지가 없습니다',
                        style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                      ),
                    )
                    : _EditNoticeList(
                      starredHashes: starredHashes,
                      selectedHashes: _selectedHashes,
                      onSelectNotice: (notice) {
                        setState(() {
                          _selectedHashes.contains(notice)
                              ? _selectedHashes.remove(notice)
                              : _selectedHashes.add(notice);
                        });
                      },
                    ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30.h),
            child: SizedBox(
              width: 301.w,
              height: 43.h,
              child: TextButton(
                onPressed:
                    _selectedHashes.isEmpty
                        ? null
                        : () {
                          final userNotifier = ref.read(userProvider.notifier);
                          for (final notice in _selectedHashes) {
                            userNotifier.toggleStarredNotice(notice);
                          }
                          Navigator.pop(context); // 편집 화면 닫기
                        },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFE64343),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r), // 반응형 둥근 모서리
                  ),
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '삭제',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// notice_tile의 복사본 이용해 수정함, 추후 리팩토링 고려 (위젯 통합 및 재사용용)
class _EditNoticeList extends StatelessWidget {
  final List<String> starredHashes;
  final Set<String> selectedHashes;
  final Function(String) onSelectNotice;

  const _EditNoticeList({
    required this.starredHashes,
    required this.selectedHashes,
    required this.onSelectNotice,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: starredHashes.length,
      itemBuilder: (BuildContext context, int index) {
        final reversedIndex = starredHashes.length - 1 - index;
        final hash = starredHashes[reversedIndex];
        final isSelected = selectedHashes.contains(hash);

        return FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance.collection('notices').doc(hash).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ListTile(title: Text("불러오는 중..."));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const ListTile(title: Text("공지 없음"));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final title = data['title'] ?? '';
            final date = data['date'] ?? '';
            final views = data['views'] ?? 0;

            return Column(
              children: [
                ListTile(
                  title: Text(
                    title,
                    style: TextStyle(fontSize: 15.sp, color: Colors.black),
                  ),
                  subtitle: Text(
                    '$date | 조회수: $views',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                  trailing: GestureDetector(
                    onTap: () => onSelectNotice(hash),
                    child: Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isSelected ? const Color(0xFF0B5B42) : Colors.grey,
                      size: 26.sp,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1.h,
                  indent: 16.w,
                  endIndent: 16.w,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
