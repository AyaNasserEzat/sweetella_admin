import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/di/service_locator.dart';
import 'package:sweetella_admin/core/theme/app_theme.dart';
import 'package:sweetella_admin/features/home/presentation/pages/home_dashboard_page.dart';
import 'package:sweetella_admin/firebase_options.dart';
import 'package:sweetella_admin/l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    setupServiceLocator();
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'Firebase initialization',
      ),
    );
    rethrow;
  }
  runApp(const SweetellaApp());
}

class SweetellaApp extends StatelessWidget {
  const SweetellaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sweetella Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeDashboardPage(),
    );
  }
}
