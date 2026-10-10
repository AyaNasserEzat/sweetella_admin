import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sweetella_admin/core/theme/theme_cubit.dart';

void main() {
  late _MemoryStorage storage;
  late ThemeCubit cubit;

  setUp(() {
    storage = _MemoryStorage();
    HydratedBloc.storage = storage;
    cubit = ThemeCubit();
  });

  tearDown(() async {
    await cubit.close();
  });

  test('serializes supported modes and defaults invalid data to system', () {
    expect(cubit.toJson(ThemeMode.light), {'themeMode': 'light'});
    expect(cubit.toJson(ThemeMode.dark), {'themeMode': 'dark'});
    expect(cubit.toJson(ThemeMode.system), {'themeMode': 'system'});

    expect(cubit.fromJson({'themeMode': 'light'}), ThemeMode.light);
    expect(cubit.fromJson({'themeMode': 'dark'}), ThemeMode.dark);
    expect(cubit.fromJson({'themeMode': 'system'}), ThemeMode.system);
    expect(cubit.fromJson({'themeMode': 'unknown'}), ThemeMode.system);
  });

  test('toggleTheme emits and persists the selected mode', () async {
    cubit.toggleTheme(ThemeMode.dark);

    expect(cubit.state, ThemeMode.dark);
    expect(storage.values, isNotEmpty);

    await cubit.close();
    cubit = ThemeCubit();

    expect(cubit.state, ThemeMode.dark);
  });
}

class _MemoryStorage implements Storage {
  final Map<String, dynamic> values = {};

  @override
  Future<void> clear() async {
    values.clear();
  }

  @override
  Future<void> close() async {}

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }

  @override
  dynamic read(String key) => values[key];

  @override
  Future<void> write(String key, dynamic value) async {
    values[key] = value;
  }
}
