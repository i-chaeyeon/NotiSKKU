import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/data/major_data.dart';
import 'package:notiskku/data/temp_starred_notices.dart';
import 'package:notiskku/models/major.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/providers/selected_major_provider.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/tabs/screen_main_search.dart';
import 'package:notiskku/widget/bar/bar_categories.dart';
import 'package:notiskku/widget/bar/bar_notices.dart';
import 'package:notiskku/widget/list/list_notices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class _NoticeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _NoticeAppBar();

  void _updateMajorIndex(WidgetRef ref, bool isLeft, int listLength) {
    final notifier = ref.read(selectedMajorIndexProvider.notifier);
    final currentIndex = ref.read(selectedMajorIndexProvider);

    final newIndex =
        isLeft
            ? (currentIndex - 1 + listLength) % listLength
            : (currentIndex + 1) % listLength;

    notifier.state = newIndex;
    ref.read(userProvider.notifier).saveTempStarred(tempStarredNotices);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final majorIndex = ref.watch(selectedMajorIndexProvider);

    // currentMajor에 현재 화면에 렌더링 되는 학과가 선택됨
    String currentMajor = '';
    userState.selectedMajors.isEmpty
        ? currentMajor = ' '
        : currentMajor =
            userState
                .selectedMajors[majorIndex.clamp(
                  0,
                  userState.selectedMajors.length - 1,
                )]
                .major;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(10.0),
        child: Image.asset('assets/images/greenlogo_fix.png', width: 40),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 좌측 화살표
          userState.selectedMajors.length > 1
              ? IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.black, size: 24.w),
                onPressed: () {
                  _updateMajorIndex(ref, true, userState.selectedMajors.length);
                  ref
                      .read(userProvider.notifier)
                      .saveTempStarred(tempStarredNotices);
                },
                // splashRadius: 20.r, // 터치 효과 반경 조정 (선택사항임)
              )
              : const SizedBox.shrink(),
          // 학과 명
          userState.selectedMajors.isEmpty
              ? Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '학과를 선택해 주세요',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
              : Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    currentMajor,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
          // 우측 화살표
          userState.selectedMajors.length > 1
              ? IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                  size: 24.w,
                ),
                onPressed: () {
                  _updateMajorIndex(
                    ref,
                    false,
                    userState.selectedMajors.length,
                  );
                  ref
                      .read(userProvider.notifier)
                      .saveTempStarred(tempStarredNotices);
                },
                // splashRadius: 20.r,
              )
              : const SizedBox.shrink(),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () {
              ref
                  .read(userProvider.notifier)
                  .saveTempStarred(tempStarredNotices);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScreenMainSearch()),
              );
            },
            child: Image.asset('assets/images/search_fix.png', width: 30.w),
          ),
        ),
      ],
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ScreenMainNotice extends ConsumerWidget {
  const ScreenMainNotice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final majorIndex = ref.watch(selectedMajorIndexProvider);
    final typeState = ref.watch(barNoticesProvider);

    final currentMajor =
        userState.selectedMajors.isEmpty
            ? ''
            : userState
                .selectedMajors[majorIndex.clamp(
                  0,
                  userState.selectedMajors.length - 1,
                )]
                .major;

    final currentDept =
        majors
            .firstWhere(
              (m) => m.major == currentMajor,
              orElse: () => Major(department: '', major: ''), // 기본값 지정
            )
            .department;

    final currentCategory = ref.watch(barCategoriesProvider);
    String getCategory(Categories category) {
      switch (category) {
        case Categories.all:
          return '[전체]';
        case Categories.academics:
          return '[학사]';
        case Categories.admission:
          return '[입학]';
        case Categories.employment:
          return '[취업]';
        case Categories.recruitment:
          return '[채용/모집]';
        case Categories.scholarship:
          return '[장학]';
        case Categories.eventsAndSeminars:
          return '[행사/세미나]';
        case Categories.general:
          return '[일반]';
      }
    }

    Future<Widget> getNoticesWidget(
      Notices type,
      String department,
      String major,
      Categories category,
    ) async {
      late QuerySnapshot snapshot;
      final currentCategoryLabel = getCategory(currentCategory);

      if ((type == Notices.dept || type == Notices.major) && major == '') {
        return Text("공지 선택하고 오세요");
      }

      if (type == Notices.common) {
        if (currentCategoryLabel == '[전체]') {
          snapshot =
              await FirebaseFirestore.instance
                  .collection('notices')
                  .where('type', isEqualTo: "전체")
                  .orderBy('date', descending: true)
                  .get();
        } else {
          snapshot =
              await FirebaseFirestore.instance
                  .collection('notices')
                  .where('type', isEqualTo: "전체")
                  .where('category', isEqualTo: currentCategoryLabel)
                  .orderBy('date', descending: true)
                  .get();
        }
      } else if (type == Notices.dept) {
        snapshot =
            await FirebaseFirestore.instance
                .collection('notices')
                .where('department', isEqualTo: department)
                .orderBy('date', descending: true)
                .get();
      } else if (type == Notices.major) {
        snapshot =
            await FirebaseFirestore.instance
                .collection('notices')
                .where('major', isEqualTo: major)
                .orderBy('date', descending: true)
                .get();
      } else {
        return const Center(child: Text("잘못된 타입입니다."));
      }

      final notices =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['hash'] = doc.id;
            return data;
          }).toList();

      return ListNotices(notices: notices);
    }

    return Scaffold(
      appBar: const _NoticeAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          BarNotices(),
          SizedBox(height: 6.h),
          if (typeState == Notices.common) ...[
            BarCategories(),
            SizedBox(height: 10.h),
          ],
          Expanded(
            child: FutureBuilder<Widget>(
              future: getNoticesWidget(
                typeState,
                currentDept,
                currentMajor,
                currentCategory,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else {
                  return snapshot.data ?? const Center(child: Text('공지 없음'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
