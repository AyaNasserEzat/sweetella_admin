import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppTokens.light.color.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppTokens.light.color.brand,
        brightness: Brightness.light,
      ),
      extensions: const [AppTokens.light],
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppTokens.dark.color.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppTokens.dark.color.brand,
        brightness: Brightness.dark,
      ),
      extensions: const [AppTokens.dark],
    );
  }
}
