import 'package:flutter/material.dart';
import 'package:notiskku/widget/popup/popup_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPopup extends StatelessWidget {
  const FeedbackPopup({super.key});

  Future<void> _launchChat() async {
    const url = 'https://open.kakao.com/o/gKYMY3Wg';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupUi(
      title: '문의 / 건의',
      onConfirm: () => Navigator.of(context).pop(),
      content: Column(
        children: [
          const Text(
            '문의 및 건의는 아래의 카카오톡 오픈채팅을 이용해 주세요.\n답변은 2~3일 정도 소요될 수 있습니다.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _launchChat,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.grey[300],
              child: const Text(
                'https://open.kakao.com/o/gKYMY3Wg',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
