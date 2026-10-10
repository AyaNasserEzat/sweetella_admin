import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sweetella_admin/core/theme/app_theme.dart';
import 'package:sweetella_admin/core/theme/theme_cubit.dart';
import 'package:sweetella_admin/features/home/presentation/widgets/sidebar_footer.dart';
import 'package:sweetella_admin/l10n/generated/app_localizations.dart';

void main() {
  late ThemeCubit themeCubit;

  setUp(() {
    HydratedBloc.storage = _MemoryStorage();
    themeCubit = ThemeCubit();
  });

  tearDown(() async {
    await themeCubit.close();
  });

  testWidgets('dark mode switch updates the theme', (tester) async {
    await tester.pumpWidget(_testApp(themeCubit));

    expect(find.text('Dark mode'), findsOneWidget);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(themeCubit.state, ThemeMode.dark);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  testWidgets('dark mode switch label is localized in Arabic', (tester) async {
    await tester.pumpWidget(_testApp(themeCubit, locale: const Locale('ar')));

    expect(find.text('الوضع الداكن'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(Switch))),
      TextDirection.rtl,
    );
  });
}

Widget _testApp(ThemeCubit themeCubit, {Locale locale = const Locale('en')}) {
  return BlocProvider.value(
    value: themeCubit,
    child: BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          locale: locale,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: SidebarFooter()),
        );
      },
    ),
  );
}

class _MemoryStorage implements Storage {
  final Map<String, dynamic> _values = {};

  @override
  Future<void> clear() async {
    _values.clear();
  }

  @override
  Future<void> close() async {}

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  dynamic read(String key) => _values[key];

  @override
  Future<void> write(String key, dynamic value) async {
    _values[key] = value;
  }
}
