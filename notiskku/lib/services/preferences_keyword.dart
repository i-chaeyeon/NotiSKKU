import 'dart:convert';

import 'package:notiskku/models/keyword.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeywordPreferences {
  static const _key = 'keywordPrefs';

  static Future<void> save(List<Keyword> prefs) async {
    final sp = await SharedPreferences.getInstance();
    final jsonList = prefs.map((p) => jsonEncode(p.toJson())).toList();
    await sp.setStringList(_key, jsonList);
  }

  static Future<List<Keyword>> load() async {
    final sp = await SharedPreferences.getInstance();
    final jsonList = sp.getStringList(_key) ?? [];
    return jsonList.map((str) => Keyword.fromJson(jsonDecode(str))).toList();
  }

  static Future<void> toggleKeywordNotification(String keyword) async {
    List<Keyword> prefs = await KeywordPreferences.load();

    List<Keyword> updated =
        prefs.map((k) {
          if (k.keyword == keyword) {
            return Keyword(
              keyword: k.keyword,
              defined: k.defined,
              receiveNotification: !k.receiveNotification,
            );
          } else {
            return k;
          }
        }).toList();

    await KeywordPreferences.save(updated);
  }
}
