import 'package:url_launcher/url_launcher.dart';

class LaunchUrlService {
  // URL을 여는 함수
  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(Uri.encodeFull(url));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
