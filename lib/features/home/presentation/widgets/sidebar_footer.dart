import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class SidebarFooter extends StatelessWidget {
  const SidebarFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Padding(
      padding: EdgeInsets.all(tokens.space.md),
      child: InkWell(
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
    );
  }
}
