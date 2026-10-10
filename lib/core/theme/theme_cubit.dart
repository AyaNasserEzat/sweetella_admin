import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  static const _jsonKey = 'themeMode';

  void toggleTheme(ThemeMode newTheme) {
    emit(newTheme);
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return switch (json[_jsonKey]) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {_jsonKey: state.name};
  }
}
