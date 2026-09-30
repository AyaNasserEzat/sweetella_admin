import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/layout/breakpoints.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({required this.tokens, super.key});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = AppBreakpoints.fromWidth(constraints.maxWidth);
        final compact = breakpoint == AppBreakpoint.compact;

        return Wrap(
          spacing: tokens.space.lg,
          runSpacing: tokens.space.lg,
          alignment: compact ? WrapAlignment.start : WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dashboard', style: tokens.text.display),
                SizedBox(height: tokens.space.xs),
                Text(
                  'Welcome back, Admin 👋',
                  style: tokens.text.body.copyWith(
                    color: tokens.color.textSecondary,
                  ),
                ),
              ],
            ),
            _DashboardHeaderActions(tokens: tokens, compact: compact),
          ],
        );
      },
    );
  }
}

class _DashboardHeaderActions extends StatelessWidget {
  const _DashboardHeaderActions({required this.tokens, required this.compact});

  final AppTokens tokens;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SearchButton(tokens: tokens),
          SizedBox(width: tokens.space.md),
          _NotificationButton(tokens: tokens),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SearchField(tokens: tokens),
        SizedBox(width: tokens.space.md),
        _NotificationButton(tokens: tokens),
        SizedBox(width: tokens.space.md),
        _ProfileButton(tokens: tokens),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.tokens});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tokens.size.searchWidth,
      padding: EdgeInsets.symmetric(
        horizontal: tokens.space.md,
        vertical: tokens.space.sm,
      ),
      decoration: BoxDecoration(
        color: tokens.color.surface,
        borderRadius: BorderRadius.circular(tokens.radius.xl),
        border: Border.all(color: tokens.color.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: tokens.color.textSecondary,
            size: tokens.size.icon,
          ),
          SizedBox(width: tokens.space.sm),
          Expanded(
            child: Text(
              'Search',
              style: tokens.text.body.copyWith(
                color: tokens.color.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton({required this.tokens});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tokens.size.profileAvatar,
      height: tokens.size.profileAvatar,
      decoration: BoxDecoration(
        color: tokens.color.surface,
        borderRadius: BorderRadius.circular(tokens.radius.xl),
        border: Border.all(color: tokens.color.border),
      ),
      child: Icon(
        Icons.search_rounded,
        color: tokens.color.icon,
        size: tokens.size.icon,
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.tokens});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tokens.size.profileAvatar,
      height: tokens.size.profileAvatar,
      decoration: BoxDecoration(
        color: tokens.color.surface,
        borderRadius: BorderRadius.circular(tokens.radius.xl),
        border: Border.all(color: tokens.color.border),
      ),
      child: Icon(
        Icons.notifications_none_rounded,
        color: tokens.color.icon,
        size: tokens.size.icon,
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  const _ProfileButton({required this.tokens});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: tokens.size.profileAvatar,
          height: tokens.size.profileAvatar,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(tokens.radius.xl),
          ),
        ),
        SizedBox(width: tokens.space.sm),
        Text('Admin', style: tokens.text.titleSmall),
      ],
    );
  }
}
