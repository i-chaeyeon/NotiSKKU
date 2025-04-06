import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:notiskku/models/notice.dart';

class GoogleSheetsAPI {
  static const _commonSheetId = "1RPTHVpyEJb4mZs9sz10E5OwIpZB-3YJcfrg5H7dFqhM";
  static const _deptSheetId = "1YX53hQ1oHjAhl8wvsa6nIq6P5Eh0SMyV8SaN8hsPyTg";
  static const _majorSheetId = "1XOv61iZQiPwc2CeqU4lnZsnmpUIhp4Tnjcsk84mHihU";

  /// Google Sheets API 연결 메소드
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

  /// 메인 메소드
  static Future<List<Notice>> readSheetData({
    required String sheetId,
    required String sheetName,
    int startRow = 1,
    int limit = 10,
  }) async {
    final sheetsApi = await _getSheetsApi();
    if (sheetsApi == null) return [];

    final response = await sheetsApi.spreadsheets.values.get(
      sheetId,
      sheetName,
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

  ///
  /// HELPERS
  ///
  static Future<List<Notice>> readCommonData({
    int startRow = 1,
    int limit = 10,
  }) {
    return readSheetData(
      sheetId: _commonSheetId,
      sheetName: "시트1",
      startRow: startRow,
      limit: limit,
    );
  }

  static Future<List<Notice>> readDeptData({
    required String dept,
    int startRow = 1,
    int limit = 10,
  }) {
    return readSheetData(
      sheetId: _deptSheetId,
      sheetName: dept,
      startRow: startRow,
      limit: limit,
    );
  }

  static Future<List<Notice>> readMajorData({
    required String major,
    int startRow = 1,
    int limit = 10,
  }) {
    return readSheetData(
      sheetId: _majorSheetId,
      sheetName: major,
      startRow: startRow,
      limit: limit,
    );
  }
}
