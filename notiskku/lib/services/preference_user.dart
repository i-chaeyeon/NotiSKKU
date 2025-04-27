import 'dart:convert';

import 'package:notiskku/models/keyword.dart';
import 'package:notiskku/models/major.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _majorKey = 'userPrefs_majors';
  static const _keywordKey = 'userPrefs_keywords';
  static const _starredKey = 'userPrefs_starred';
  static const _recentSearchKey = 'userPrefs_recent_search';

  // 전공 관련
  static Future<void> saveMajor(List<Major> prefs) async {
    final sp = await SharedPreferences.getInstance();
    final jsonList = prefs.map((p) => jsonEncode(p.toJson())).toList();
    await sp.setStringList(_majorKey, jsonList);
  }

  static Future<List<Major>> loadMajor() async {
    final sp = await SharedPreferences.getInstance();
    final jsonList = sp.getStringList(_majorKey) ?? [];
    return jsonList.map((str) => Major.fromJson(jsonDecode(str))).toList();
  }

  // 키워드 관련
  static Future<void> saveKeywords(List<Keyword> prefs) async {
    final sp = await SharedPreferences.getInstance();
    final jsonList = prefs.map((p) => jsonEncode(p.toJson())).toList();
    await sp.setStringList(_keywordKey, jsonList);
  }

  static Future<List<Keyword>> loadKeywords() async {
    final sp = await SharedPreferences.getInstance();
    final jsonList = sp.getStringList(_keywordKey) ?? [];
    return jsonList.map((str) => Keyword.fromJson(jsonDecode(str))).toList();
  }

  // 별표 관련
  static Future<void> saveStarred(List<String> hash) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_starredKey, hash);
  }

  static Future<List<String>?> loadStarred() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_starredKey);
  }

  static Future<void> removeStarred(List<String> hashesToRemove) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = prefs.getStringList(_starredKey) ?? [];

    final updatedList =
        currentList.where((hash) => !hashesToRemove.contains(hash)).toList();

    await prefs.setStringList(_starredKey, updatedList);
  }

  static Future<void> clearStarred() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_starredKey);
  }

  // 최근 검색어 관련
  static Future<void> saveRecentSearch(List<String> word) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentSearchKey, word);
  }

  static Future<List<String>?> loadRecentSearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentSearchKey);
  }
}
