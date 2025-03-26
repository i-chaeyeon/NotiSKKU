import 'package:flutter/material.dart';
import 'package:notiskku/widget/popup/popup_ui.dart';

class VersionNoticePopup extends StatelessWidget {
  const VersionNoticePopup({Key? key}) : super(key: key);

  Widget _buildVersionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNotice('서버 정기점검 (완료)', '2024.08.21', 'NotiSKKU 정기점검 완료되었습니다.'),
        _buildNotice('서버 정기점검 (완료)', '2024.06.15', 'NotiSKKU 서버 점검이 성공적으로 완료되었습니다.'),
        _buildNotice('서버 정기점검 (완료)', '2024.04.10', 'NotiSKKU의 점검 작업이 정상적으로 완료되었습니다.'),
      ],
    );
  }

  Widget _buildNotice(String title, String date, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('[$date]', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 5),
        Text('- $content', style: const TextStyle(fontSize: 16)),
        Divider(color: Colors.grey[600], thickness: 1, height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupUi(
      title: '버전 및 공지',
      onConfirm: () => Navigator.of(context).pop(),
      content: _buildVersionContent(),
    );
  }
}
