import 'package:flutter/material.dart';

class VersionNoticePopup extends StatelessWidget {
  const VersionNoticePopup({Key? key}) : super(key: key);

  Widget _buildVersionContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '서버 정기점검 (완료)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          '[2024.08.21]',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          '- NotiSKKU 정기점검 완료되었습니다.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        Divider(
          color: Colors.grey[600],
          thickness: 1,
          height: 20,
        ),
        Text(
          '서버 정기점검 (완료)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          '[2024.06.15]',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          '- NotiSKKU 서버 점검이 성공적으로 완료되었습니다.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        Divider(
          color: Colors.grey[600],
          thickness: 1,
          height: 20,
        ),
        Text(
          '서버 정기점검 (완료)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          '[2024.04.10]',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          '- NotiSKKU의 점검 작업이 정상적으로 완료되었습니다.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '버전 및 공지',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B5B42),
                ),
              ),
              const Divider(
                color: Color(0xFF0B5B42),
                thickness: 3,
                height: 20,
              ),
              _buildVersionContent(context),
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
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      '확인',
                      style:
                          TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
