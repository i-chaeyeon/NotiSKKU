import 'package:flutter/material.dart';
import 'package:notiskku/widget/popup/popup_ui.dart';

class TermsOfServicePopup extends StatelessWidget {
  const TermsOfServicePopup({super.key});

  Widget _buildTermsContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '개요',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '본 이용약관은 "노티스꾸" 앱(이하 "본 앱")의 이용과 관련하여 이용자와 팀 노티스꾸(이하 "저희 팀") 간의 권리, 의무 및 책임사항을 규정합니다.\n'
            '본 약관은 2025년 4월 2일부터 적용됩니다.\n',
          ),

          /// 제1조
          Text(
            '\n제1조 (서비스의 목적 및 내용)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '• 본 앱은 대학교의 다양한 공지사항을 하나의 화면에 모아 사용자에게 제공하는 정보 서비스입니다.\n'
            '• 회원가입 및 로그인 기능 없이 누구나 이용할 수 있습니다.\n'
            '• 서비스 내용은 학교 또는 기관의 사정에 따라 변동될 수 있으며, 정보의 정확성이나 최신성은 보장되지 않습니다.\n',
          ),

          /// 제2조
          Text('\n제2조 (지적재산권)', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            '• 본 앱에서 사용되는 UI, 로고, 디자인, 코드, 기능 등은 저희 팀의 창작물이며, 지적재산권 보호를 받습니다.\n'
            '• 이용자는 이를 무단으로 복제, 배포, 수정할 수 없습니다.\n',
          ),

          /// 제3조
          Text('\n제3조 (책임의 한계)', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            '• 본 앱은 단순 정보 제공 서비스로, 공지사항의 정확성이나 신뢰성에 대해 법적 책임을 지지 않습니다.\n'
            '• 사용자가 본 앱을 통해 얻은 정보로 인해 발생한 손해에 대해 책임지지 않습니다.\n',
          ),

          /// 제4조
          Text(
            '\n제4조 (이용자의 권리와 의무)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '• 이용자는 본 약관에 따라 앱을 올바르게 사용해야 하며, 앱의 정상적인 운영을 방해하지 않아야 합니다.\n'
            '• 앱 기능을 악용하거나 불법적인 목적으로 사용할 수 없습니다.\n',
          ),

          /// 제5조
          Text('\n제5조 (약관 변경)', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            '• 저희 팀은 필요한 경우 본 약관을 수정할 수 있으며, 변경 시 앱 내 공지 또는 팝업을 통해 안내합니다.\n'
            '• 변경된 약관은 공지한 날로부터 효력을 발생합니다.\n',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupUi(
      title: '이용약관',
      onConfirm: () => Navigator.of(context).pop(),
      content: _buildTermsContent(),
    );
  }
}
