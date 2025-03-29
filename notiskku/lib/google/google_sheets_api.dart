import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:notiskku/models/notice.dart';
import 'package:notiskku/services/preference_services.dart';

class GoogleSheetsAPI {
  static const _commonSheetId = "1RPTHVpyEJb4mZs9sz10E5OwIpZB-3YJcfrg5H7dFqhM";
  static const _deptSheetId = "1YX53hQ1oHjAhl8wvsa6nIq6P5Eh0SMyV8SaN8hsPyTg";
  static const _majorSheetId = "1XOv61iZQiPwc2CeqU4lnZsnmpUIhp4Tnjcsk84mHihU";

  /// Google Sheets API 연결 메소드
  /// _getSheetsApi
  static Future<SheetsApi?> _getSheetsApi() async {
    final credentials = await rootBundle.loadString('assets/credentials.json');
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(
      json.decode(credentials),
    );

    final client = await clientViaServiceAccount(serviceAccountCredentials, [
      SheetsApi.spreadsheetsScope,
    ]);
    return SheetsApi(client);
  }

  /// 전체 공지 시트 데이터를 Notice 리스트로 변환해서 리턴
  /// readCommonData(startRow, limit)
  static Future<List<Notice>> readCommonData({
    int startRow = 1,
    int limit = 10,
  }) async {
    final sheetsApi = await _getSheetsApi();
    if (sheetsApi == null) return [];

    final response = await sheetsApi.spreadsheets.values.get(
      _commonSheetId,
      "시트1",
    );

    final allData = response.values ?? [];

    return allData.isNotEmpty
        ? allData.reversed
            .skip(startRow - 1)
            .take(limit)
            .map((row) => Notice.fromSheet(row.cast<String>()))
            .toList()
        : [];
  }

  /// 단과대별 공지 시트 데이터를 Notice 리스트로 변환해서 리턴
  /// readDeptData(majors, startRow, limit)
  /// TODO: 전공 여러 개인 경우 어떻게 처리할 것인지
  static Future<List<Notice>> readDeptData({
    required List<String> majors,
    int startRow = 1,
    int limit = 10,
  }) async {
    final sheetsApi = await _getSheetsApi();
    if (sheetsApi == null) return [];

    final response = await sheetsApi.spreadsheets.values.get(
      _deptSheetId,
      "시트1",
    );

    final allData = response.values ?? [];

    return allData.isNotEmpty
        ? allData.reversed
            .skip(startRow - 1)
            .take(limit)
            .map((row) => Notice.fromSheet(row.cast<String>()))
            .toList()
        : [];
  }

  /// 학과별 공지 시트 데이터를 Notice 리스트로 변환해서 리턴
  /// readMajorData(majors, startRow, limit)
  /// TODO: 전공 여러 개인 경우 어떻게 처리할 것인지
  static Future<List<Notice>> readMajorData({
    required List<String> majors,
    int startRow = 1,
    int limit = 10,
  }) async {
    final sheetsApi = await _getSheetsApi();
    if (sheetsApi == null) return [];

    final response = await sheetsApi.spreadsheets.values.get(
      _majorSheetId,
      "시트1",
    );

    final allData = response.values ?? [];

    return allData.isNotEmpty
        ? allData.reversed
            .skip(startRow - 1)
            .take(limit)
            .map((row) => Notice.fromSheet(row.cast<String>()))
            .toList()
        : [];
  }
}
