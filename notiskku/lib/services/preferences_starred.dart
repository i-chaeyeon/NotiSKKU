import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:notiskku/models/notice.dart';

class NoticePreferences {
  static const _key = 'savedNotices';

  static Future<void> save(List<Notice> notices) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = notices.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<List<Notice>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((str) => Notice.fromJson(jsonDecode(str))).toList();
  }

  static Future<void> remove(List<Notice> noticesToRemove) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];

    final updatedList =
        jsonList.where((str) {
          final notice = Notice.fromJson(jsonDecode(str));
          return !noticesToRemove.any(
            (n) => n.id == notice.id && n.id == notice.title,
          );
        }).toList();

    await prefs.setStringList(_key, updatedList);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
