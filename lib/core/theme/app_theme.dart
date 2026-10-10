import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => _buildTheme(AppTokens.light, Brightness.light);

  static ThemeData get dark => _buildTheme(AppTokens.dark, Brightness.dark);

  static ThemeData _buildTheme(AppTokens tokens, Brightness brightness) {
    final colors = tokens.color;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,

      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.brand,
        onPrimary: Colors.white,
        secondary: colors.brandSoft,
        onSecondary: colors.textPrimary,
        error: colors.danger,
        onError: Colors.white,
        surface: colors.surface,
        onSurface: colors.textPrimary,
      ),

      extensions: <ThemeExtension<dynamic>>[tokens],

      // iconTheme: IconThemeData(color: tokens.color.icon),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: tokens.text.title,
        iconTheme: IconThemeData(color: colors.icon),
      ),

      inputDecorationTheme: InputDecorationTheme(
        hintStyle: tokens.text.bodySmall.copyWith(color: colors.textSecondary),
        fillColor: colors.surfaceAlt,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: tokens.space.lg,
          vertical: tokens.space.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radius.md),
          borderSide: BorderSide(color: colors.brand, width: 1.5),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.brand,
          foregroundColor: Colors.white,
          disabledBackgroundColor: colors.surfaceAlt,
          disabledForegroundColor: colors.textSecondary,
          minimumSize: Size(double.infinity, tokens.size.listRowHeight),
          padding: EdgeInsets.symmetric(
            horizontal: tokens.space.xl,
            vertical: tokens.space.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.radius.md),
          ),
          elevation: 0,
          textStyle: tokens.text.button,
        ),
      ),

      dividerTheme: DividerThemeData(color: colors.border, thickness: 1),
    );
  }
}
