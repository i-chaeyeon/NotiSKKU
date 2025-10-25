import 'package:flutter/material.dart';

/// ===== Palette (Light) — from the light spec image =====
class _LightPalette {
  // Greens
  static const primaryGreen = Color(0xFF0B5B42); // 주요 버튼/포커스
  static const secondaryGreen = Color(0xFF68A18F); // 보조 강조

  // Neutrals
  static const surfaceNearWhite = Color(0xFFFAFFFE); // 카드/입력창
  static const gray600 = Color(0xFF979797); // 보조 텍스트/아이콘
  static const gray200 = Color(0xFFD9D9D9); // 구분선/테두리
  static const ink900 = Color(0xFF202123); // 본문 텍스트

  // Reds
  static const redStrong = Color(0xFFDD0300); // 에러/위험 버튼
  static const redLight = Color(0xFFE64343); // 에러 컨테이너/주의
}

/// ===== Typography (pt → px 근사) =====
/// 25pt≈33, 18pt≈24, 15pt≈20, 13pt≈17, 10pt≈13
TextTheme _lightTextTheme(String fontFamily) => TextTheme(
  displayLarge: TextStyle(
    // h1 Heavy 25pt
    fontFamily: fontFamily,
    fontWeight: FontWeight.w900,
    fontSize: 33,
    height: 1.15,
    letterSpacing: -0.5,
    color: _LightPalette.ink900,
  ),
  headlineMedium: TextStyle(
    // h2 Bold 18pt
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.2,
    color: _LightPalette.ink900,
  ),
  titleMedium: TextStyle(
    // h3 Regular 13pt
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 17,
    height: 1.35,
    color: _LightPalette.ink900,
  ),
  titleLarge: TextStyle(
    // Plain Text Regular 15pt
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    height: 1.35,
    color: _LightPalette.ink900,
  ),
  labelSmall: TextStyle(
    // Caption Light 10pt
    fontFamily: fontFamily,
    fontWeight: FontWeight.w300,
    fontSize: 13,
    height: 1.25,
    color: _LightPalette.gray600,
  ),
  bodyMedium: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.38,
    color: _LightPalette.ink900,
  ),
);

/// ===== ColorScheme (Light) =====
const _lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: _LightPalette.primaryGreen,
  onPrimary: Colors.white,
  primaryContainer: Color(0xFF1E6B55),
  onPrimaryContainer: Colors.white,

  secondary: _LightPalette.secondaryGreen,
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFF7FB4A4),
  onSecondaryContainer: Colors.white,

  tertiary: _LightPalette.gray600,
  onTertiary: Colors.white,
  tertiaryContainer: _LightPalette.gray200,
  onTertiaryContainer: _LightPalette.ink900,

  error: _LightPalette.redStrong,
  onError: Colors.white,
  errorContainer: _LightPalette.redLight,
  onErrorContainer: Colors.white,

  background: Colors.white,
  onBackground: _LightPalette.ink900,

  surface: _LightPalette.surfaceNearWhite,
  onSurface: _LightPalette.ink900,

  outline: _LightPalette.gray200,
  outlineVariant: _LightPalette.gray600,

  surfaceVariant: _LightPalette.gray200,
  onSurfaceVariant: _LightPalette.ink900,

  shadow: Colors.black12,
  scrim: Colors.black54,
  inverseSurface: _LightPalette.ink900,
  onInverseSurface: _LightPalette.surfaceNearWhite,
  inversePrimary: _LightPalette.secondaryGreen,
);

/// ===== Public builder =====
ThemeData buildLightTheme({String fontFamily = 'NanumSquareNeo'}) {
  final text = _lightTextTheme(fontFamily);

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: _lightScheme,
    scaffoldBackgroundColor: _lightScheme.surface,
    textTheme: text,
  );

  return base.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: _lightScheme.surface,
      foregroundColor: _lightScheme.onSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: text.headlineMedium,
    ),
    cardTheme: CardTheme(
      color: _lightScheme.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dividerColor: _lightScheme.outline,
    iconTheme: IconThemeData(color: _LightPalette.ink900),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightScheme.surface,
      hintStyle: text.labelSmall,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _lightScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _lightScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _lightScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightScheme.primary,
        foregroundColor: _lightScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _lightScheme.secondary,
        foregroundColor: _lightScheme.onSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _lightScheme.secondary,
        textStyle: text.titleMedium,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _lightScheme.surfaceVariant,
      labelStyle: text.titleMedium!,
      selectedColor: _lightScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
