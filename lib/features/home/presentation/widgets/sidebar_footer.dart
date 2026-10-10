import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/core/theme/theme_cubit.dart';

class SidebarFooter extends StatelessWidget {
  const SidebarFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Padding(
      padding: EdgeInsets.all(tokens.space.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocSelector<ThemeCubit, ThemeMode, ThemeMode>(
            selector: (themeMode) => themeMode,
            builder: (context, themeMode) {
              final themeCubit = context.read<ThemeCubit>();
              final isDark =
                  themeMode == ThemeMode.dark ||
                  (themeMode == ThemeMode.system &&
                      Theme.of(context).brightness == Brightness.dark);

              return MergeSemantics(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.l10n.darkMode,
                        style: tokens.text.body.copyWith(
                          color: tokens.color.textSecondary,
                        ),
                      ),
                    ),
                    Switch(
                      value: isDark,
                      onChanged: (enabled) {
                        themeCubit.toggleTheme(
                          enabled ? ThemeMode.dark : ThemeMode.light,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          InkWell(
            borderRadius: BorderRadius.circular(tokens.radius.md),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: tokens.space.md,
                vertical: tokens.space.sm,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.logout_rounded,
                    color: tokens.color.textSecondary,
                    size: tokens.size.icon,
                  ),
                  SizedBox(width: tokens.space.sm),
                  Text(
                    'Logout',
                    style: tokens.text.body.copyWith(
                      color: tokens.color.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
