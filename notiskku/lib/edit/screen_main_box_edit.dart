import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final starredNotices = ref.watch(starredProvider).starredNotices;
    final bool isAllSelected =
        _selectedNotices.length == starredNotices.length &&
        starredNotices.isNotEmpty;
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
                if (_selectedNotices.length == starredNotices.length) {
                  _selectedNotices.clear();
                } else {
                  _selectedNotices
                    ..clear()
                    ..addAll(starredNotices);
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
                starredNotices.isEmpty
                    ? Center(
                      child: Text(
                        '저장된 공지가 없습니다',
                        style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                      ),
                    )
                    : _EditNoticeList(
                      starredNotices: starredNotices,
                      selectedNotices: _selectedNotices,
                      onSelectNotice: (notice) {
                        setState(() {
                          _selectedNotices.contains(notice)
                              ? _selectedNotices.remove(notice)
                              : _selectedNotices.add(notice);
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
                    _selectedNotices.isEmpty
                        ? null
                        : () {
                          final notifier = ref.read(starredProvider.notifier);
                          for (final notice in _selectedNotices) {
                            notifier.toggleNotice(notice);
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
  final List<Notice> starredNotices;
  final Set<Notice> selectedNotices;
  final Function(Notice) onSelectNotice;

  const _EditNoticeList({
    required this.starredNotices,
    required this.selectedNotices,
    required this.onSelectNotice,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: starredNotices.length,
      itemBuilder: (BuildContext context, int index) {
        final reversedIndex = starredNotices.length - 1 - index;
        final notice = starredNotices[reversedIndex];
        final bool isSelected = selectedNotices.contains(notice);
        return Column(
          children: [
            ListTile(
              title: Text(
                notice.title,
                style: TextStyle(fontSize: 15.sp, color: Colors.black),
              ),
              subtitle: Text(
                '${notice.date} | 조회수: ${notice.views}',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
              trailing: GestureDetector(
                onTap: () => onSelectNotice(notice),
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
  }
}
