import 'package:flutter/material.dart';

/// ===== Palette (Dark) — from the dark spec image =====
class _DarkPalette {
  static const background = Color(0xFF17171B); // 배경
  static const surface = Color(0xFF17171B); // 카드/입력창
  static const textPrimary = Color(0xFFFAFAF8); // 일반 텍스트
  static const divider = Color(0xFF555555); // 구분선
  static const gray = Color(0xFFACACAC); // 회색 보조 텍스트

  static const greenButton = Color(0xFF0B5B42); // 초록 버튼
  static const greenWord = Color(0xFF24916F); // 초록 단어/링크

  static const redDelete = Color(0xFFC94848); // 삭제 버튼
  static const redWord = Color(0xFFA01210); // 취소(단어)·경고
}

/// ===== Typography =====
TextTheme _darkTextTheme(String fontFamily) => TextTheme(
  displayLarge: TextStyle(
    // h1 Heavy
    fontFamily: fontFamily,
    fontWeight: FontWeight.w900,
    color: _DarkPalette.textPrimary,
  ),
  headlineMedium: TextStyle(
    // h2 Bold
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    color: _DarkPalette.textPrimary,
  ),
  titleMedium: TextStyle(
    // h3 Regular
    fontFamily: fontFamily,
    fontWeight: FontWeight.w300,
    color: _DarkPalette.textPrimary,
  ),
  titleLarge: TextStyle(
    // Plain
    fontFamily: fontFamily,
    fontWeight: FontWeight.w300,
    color: _DarkPalette.textPrimary,
  ),
  labelSmall: TextStyle(
    // Caption
    fontFamily: fontFamily,
    fontWeight: FontWeight.w100,
    color: _DarkPalette.gray,
  ),
);

/// ===== ColorScheme (Dark) =====
const _darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: _DarkPalette.greenButton,
  onPrimary: Colors.white,
  primaryContainer: _DarkPalette.greenWord,
  onPrimaryContainer: Colors.white,

  secondary: _DarkPalette.greenWord,
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFF1C6C55),
  onSecondaryContainer: Colors.white,

  error: _DarkPalette.redDelete,
  onError: Colors.white,
  errorContainer: _DarkPalette.redWord,
  onErrorContainer: Colors.white,

  background: _DarkPalette.background,
  onBackground: _DarkPalette.textPrimary,

  surface: _DarkPalette.surface,
  onSurface: _DarkPalette.textPrimary,

  surfaceVariant: Color(0xFF1F1F23),
  onSurfaceVariant: _DarkPalette.textPrimary,

  outline: _DarkPalette.divider,
  outlineVariant: _DarkPalette.gray,

  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: _DarkPalette.textPrimary,
  onInverseSurface: _DarkPalette.background,
  inversePrimary: _DarkPalette.greenWord,

  tertiary: _DarkPalette.gray,
  onTertiary: _DarkPalette.background,
  tertiaryContainer: _DarkPalette.divider,
  onTertiaryContainer: Colors.white,
);

/// ===== Public builder =====
ThemeData buildDarkTheme({String fontFamily = 'NanumSquareNeoVar'}) {
  final text = _darkTextTheme(fontFamily);

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: _darkScheme,
    scaffoldBackgroundColor: _darkScheme.background,
    textTheme: text,
  );

  return base.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: _darkScheme.surface,
      foregroundColor: _darkScheme.onSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: text.headlineMedium,
    ),
    cardTheme: CardTheme(
      color: _darkScheme.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dividerColor: _darkScheme.outline,
    iconTheme: const IconThemeData(color: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkScheme.surface,
      hintStyle: text.labelSmall,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _darkScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _darkScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _darkScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkScheme.primary, // #0B5B42
        foregroundColor: _darkScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _darkScheme.error, // #C94848
        foregroundColor: _darkScheme.onError,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _darkScheme.primaryContainer, // #24916F 링크톤
        textStyle: text.titleMedium,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _darkScheme.surfaceVariant,
      labelStyle: text.titleMedium!,
      selectedColor: _darkScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
