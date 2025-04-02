import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/notice_functions/launch_url.dart'; // LaunchUrlService import 추가
import 'package:url_launcher/url_launcher.dart';

import 'package:notiskku/screen/screen_intro_alarm.dart';

// 새로 추가된 팝업 파일들 입니당 faq,문의건의,버전 및 공지....
import 'package:notiskku/widget/popup/faq_popup.dart';
import 'package:notiskku/widget/popup/feedback_popup.dart';
import 'package:notiskku/widget/popup/version_notice_popup.dart';

import 'package:notiskku/edit/screen_main_major_edit.dart';
import 'package:notiskku/edit/screen_main_keyword_edit.dart';
import 'package:notiskku/widget/popup/privacy_policy.dart'; 

class ScreenMainOthers extends StatelessWidget {
  const ScreenMainOthers({super.key});

  Future<void> _openSettings() async {
    if (Platform.isAndroid) {
      // Android 알림 설정 화면으로 이동
      const url = 'app-settings:';
      if (await canLaunch(url)) {
        await launch(url);
      }
    } else if (Platform.isIOS) {
      // iOS 알림 설정 화면으로 이동
      await launch('app-settings:');
    } else {
      print("This platform does not support settings redirection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final LaunchUrlService launchService =
        LaunchUrlService(); // LaunchUrlService 객체 생성

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset('assets/images/greenlogo_fix.png', width: 40.w),
        ),
        title: Text(
          '더보기',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true, // 타이틀 중앙 정렬
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              children: [
                // 사용자 설정 / 구독 설정 섹션
                _buildSectionDivider(),
                _buildSectionTitle('사용자 설정 / 구독 설정'),
                _buildListItem(context, '  시스템 알림 설정', openSettings: true),
                _buildListItem(
                  context,
                  '  학과 및 키워드 알림 설정',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScreenIntroAlarm(isFromOthers: true),
                      ),
                    );
                  },
                ),
                // 기존 '학과 및 키워드 편집'을 두 항목으로 분리
                _buildListItem(
                  context,
                  '  학과 편집',
                  onTap: () {
                    // 학과 편집 화면으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScreenMainMajorEdit(),
                      ),
                    );
                  },
                ),
                _buildListItem(
                  context,
                  '  키워드 편집',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScreenMainKeywordEdit(),
                      ),
                    );
                  },
                ),

                // 피드백 섹션
                _buildSectionDivider(),
                _buildSectionTitle('피드백'),
                _buildListItem(context, '  FAQ', showFAQPopup: true),
                _buildListItem(context, '  문의 / 건의', showInquiryPopup: true),
                _buildListItem(context, '  버전 및 공지', showVersionPopup: true),

                // 정보 섹션
                _buildSectionDivider(),
                _buildSectionTitle('정보'),
                _buildListItem(context, '  개인정보처리방침', showPrivacyPopup: true),
                _buildListItem(context, '  이용 약관'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Divider(
      color: Color(0xFF0B5B42), // 구분선 색상 변경
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

Widget _buildListItem(
  BuildContext context,
  String title, {
  bool showFAQPopup = false,
  bool showInquiryPopup = false,
  bool showVersionPopup = false,
  bool showPrivacyPopup = false,      // ① 개인정보처리방침 팝업용
  bool openSettings = false,
  VoidCallback? onTap,
}) {
  return ListTile(
    title: Text(title, style: TextStyle(fontSize: 19.sp, color: Colors.black)),
    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
    onTap: () {
      // 우선 onTap 콜백이 있으면 우선 실행 후 return
      if (onTap != null) {
        onTap();
        return;
      }
      if (showFAQPopup) {
        showDialog(
          context: context,
          builder: (BuildContext context) => const FAQPopup(),
        );
      } else if (showInquiryPopup) {
        showDialog(
          context: context,
          builder: (BuildContext context) => const FeedbackPopup(),
        );
      } else if (showVersionPopup) {
        showDialog(
          context: context,
          builder: (BuildContext context) => const VersionNoticePopup(),
        );
      } else if (showPrivacyPopup) {  // ② 여기서 팝업 띄움
        showDialog(
          context: context,
          builder: (BuildContext context) => const PrivacyPolicyPopup(),
        );
      }

      if (openSettings) {
        _openSettings();
      }
    },
  );
  }
}
