import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:notiskku/models/major.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/widget/button/wide_condition.dart';
import 'package:notiskku/widget/list/list_major.dart';
import 'package:notiskku/screen/screen_intro_loading.dart';

class ScreenMainMajorEdit extends ConsumerStatefulWidget {
  const ScreenMainMajorEdit({super.key});

  @override
  ConsumerState<ScreenMainMajorEdit> createState() =>
      _ScreenMainMajorEditState();
}

class _ScreenMainMajorEditState extends ConsumerState<ScreenMainMajorEdit> {
  late final List<Major> _originalMajors; // 입장 시 스냅샷
  bool _committed = false; // 완료 저장 여부

  @override
  void initState() {
    super.initState();
    final current = ref.read(userProvider).selectedMajors;
    // deep copy (필요 시 copyWith 사용)
    _originalMajors = current
        .map(
          (m) => Major(
            id: m.id,
            department: m.department,
            major: m.major,
            receiveNotification: m.receiveNotification,
          ),
        )
        .toList(growable: false);
  }

  void _restoreIfNotCommitted() {
    if (_committed) return;
    ref.read(userProvider.notifier).replaceSelectedMajors(_originalMajors);
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final isButtonEnabled = userState.selectedMajors.isNotEmpty;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // 뒤로가기 발생 시 (제스처/앱바/시스템 백 포함) 호출
        _restoreIfNotCommitted();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            '학과 선택 편집',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  '관심 학과를 선택해주세요😀\n(학과는 최대 2개까지 가능)',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: 'GmarketSans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            const Expanded(child: ListMajor()),
            SizedBox(height: 30.h),
            WideCondition(
              text: '설정 완료',
              isEnabled: isButtonEnabled,
              onPressed:
                  isButtonEnabled
                      ? () async {
                        final user = ref.read(userProvider);

                        debugPrint('-----------------------------');
                        debugPrint(
                          '⚙️ [ScreenMainMajorEdit] 학과 편집 완료 → 로딩 화면으로 이동',
                        );
                        debugPrint(
                          '선택된 학과: ${user.selectedMajors.map((m) => m.major).join(", ")}',
                        );
                        debugPrint(
                          '알림 설정(major): '
                          '${user.selectedMajors.map((m) => "${m.major}=${m.receiveNotification}").join(", ")}',
                        );
                        debugPrint('-----------------------------');

                        _committed = true; // 완료 확정 → 뒤로가기 복원 방지

                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => const ScreenIntroLoading(
                                  isFromOthers: true,
                                ),
                          ),
                        );
                      }
                      : null,
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
