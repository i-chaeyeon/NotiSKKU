import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ===== Palette (Dark) =====
class DarkPalette {
  static const background = Color(0xFF17171B); // 배경
  static const textPrimary = Color(0xFFFAFAF8); // 일반 텍스트
  static const lineGray = Color(0xFF555555); // 구분선
  static const gray = Color(0xFFACACAC); // 회색 보조 텍스트

  static const mainGreen = Color(0xFF24916F); // 메인 초록 (버튼/포커스)
  static const subGreen = Color(0xFF0B5B42); // 서브 초록 (링크/포인트)

  static const mainRed = Color(0xFFC94848); // 삭제 버튼
  static const subRed = Color(0xFFA01210); // 경고/취소 텍스트
}

/// ===== Typography (Dark) =====
TextTheme darkTextTheme(String fontFamily) => TextTheme(
  // Display / Headline
  headlineLarge: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w900,
    fontSize: 25.sp,
    color: DarkPalette.textPrimary,
  ),
  headlineMedium: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 18.sp,
    color: DarkPalette.textPrimary,
  ),
  headlineSmall: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 13.sp,
    color: DarkPalette.textPrimary,
  ),

  bodyMedium: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w300,
    fontSize: 15.sp,
    color: DarkPalette.textPrimary,
  ),
  labelSmall: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w100,
    fontSize: 10.sp,
    color: DarkPalette.gray,
  ),

  // 추가: displayMedium은 그대로 유지
  displayMedium: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w300,
    fontSize: 15.sp,
    color: DarkPalette.textPrimary,
  ),
);

/// ===== Theme Builder (M3 최소 ColorScheme + 팔레트 오버라이드) =====
ThemeData buildDarkTheme({String fontFamily = 'NanumSquareNeo'}) {
  final text = darkTextTheme(fontFamily);

  // 최소 ColorScheme: primary/secondary/on* 대비만 맞춰서 지정
  final scheme = const ColorScheme.dark().copyWith(
    primary: DarkPalette.mainGreen,
    onPrimary: DarkPalette.textPrimary,
    secondary: DarkPalette.subGreen,
    onSecondary: DarkPalette.textPrimary,
    surface: DarkPalette.background,
    onSurface: DarkPalette.textPrimary,
    error: DarkPalette.mainRed,
    onError: DarkPalette.textPrimary,
    outline: DarkPalette.lineGray,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: DarkPalette.background,
    textTheme: text,
    // ===== AppBarTheme
    appBarTheme: AppBarTheme(
      backgroundColor: DarkPalette.background,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: DarkPalette.textPrimary),
      titleTextStyle: text.headlineMedium,
    ),
    dividerTheme: const DividerThemeData(
      color: DarkPalette.lineGray,
      thickness: 1,
      space: 1,
    ),
  );

  return base;
}
