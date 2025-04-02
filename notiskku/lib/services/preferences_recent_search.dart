import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchPreferences {
  static const _key = 'recentSearch';

  static Future<void> saveSearch(List<String> word) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, word);
  }

  static Future<List<String>?> getSavedSearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key);
  }
}
