import 'package:flutter/material.dart';
import 'package:notiskku/widget/popup/popup_ui.dart';

class FAQPopup extends StatelessWidget {
  const FAQPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupUi(
      title: 'FAQ',
      onConfirm: () => Navigator.of(context).pop(),
      content: Column(
        children: [
          const SizedBox(height: 15),
          Image.asset(
            'assets/images/to_be_implemented_fix.png',
            width: 80,
            height: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            '서비스 준비 중입니다',
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
