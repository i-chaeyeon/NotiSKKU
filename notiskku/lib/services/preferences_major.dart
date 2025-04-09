import 'dart:convert';

import 'package:notiskku/models/major.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MajorPreferences {
  static const _key = 'majorPrefs';

  static Future<void> save(List<Major> prefs) async {
    final sp = await SharedPreferences.getInstance();
    final jsonList = prefs.map((p) => jsonEncode(p.toJson())).toList();
    await sp.setStringList(_key, jsonList);
  }

  static Future<List<Major>> load() async {
    final sp = await SharedPreferences.getInstance();
    final jsonList = sp.getStringList(_key) ?? [];
    return jsonList.map((str) => Major.fromJson(jsonDecode(str))).toList();
  }

  static Future<void> toggleMajorNotification(String major) async {
    List<Major> prefs = await MajorPreferences.load();

    List<Major> updated =
        prefs.map((m) {
          if (m.major == major) {
            return Major(
              department: m.department,
              major: m.major,
              receiveNotification: !m.receiveNotification,
            );
          } else {
            return m;
          }
        }).toList();

    await MajorPreferences.save(updated);
  }
}
