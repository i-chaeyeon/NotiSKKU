import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPopup extends StatelessWidget {
  const FeedbackPopup({Key? key}) : super(key: key);

  Future<void> _launchChat() async {
    const url = 'https://open.kakao.com/o/gKYMY3Wg';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // URL 실행 실패 시 처리
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '문의 / 건의',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B5B42),
              ),
            ),
            const Divider(color: Color(0xFF0B5B42), thickness: 3, height: 20),
            const Text(
              '문의 및 건의는 아래의 카카오톡 오픈채팅을 이용해 주세요.\n답변은 2~3일 정도 소요될 수 있습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
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
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B5B42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    '확인',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
