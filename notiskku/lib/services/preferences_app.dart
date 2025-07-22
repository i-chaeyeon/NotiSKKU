import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const _keyFirstLaunch = 'isFirstLaunch';

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirst = prefs.getBool(_keyFirstLaunch) ?? true;

    if (isFirst) {
      await prefs.setBool(_keyFirstLaunch, false);
    }

    return isFirst;
  }

  static Future<void> resetFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFirstLaunch);
  }
}
