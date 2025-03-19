import 'package:flutter/material.dart';

class FAQPopup extends StatelessWidget {
  const FAQPopup({Key? key}) : super(key: key);

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
            // 팝업 제목
            const Text(
              'FAQ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B5B42),
              ),
            ),
            const Divider(color: Color(0xFF0B5B42), thickness: 3, height: 20),
            //  콘텐츠 부분
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
            const SizedBox(height: 20),
            // 확인 버튼
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
