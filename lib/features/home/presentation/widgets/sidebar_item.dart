import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

import 'sidebar_item_data.dart';

class SidebarItem extends StatelessWidget {
  const SidebarItem({
    required this.item,
    required this.active,
    required this.onTap,
    super.key,
  });

  final SidebarItemData item;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: EdgeInsets.only(bottom: tokens.space.sm),
      child: AnimatedContainer(
        duration: tokens.motion.short,
        decoration: BoxDecoration(
          color: active ? tokens.color.brandSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(tokens.radius.md),
        ),
        child: ListTile(
          dense: true,
          selected: active,
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(horizontal: tokens.space.md),
          leading: Icon(
            item.icon,
            color: active ? tokens.color.brand : tokens.color.textSecondary,
            size: tokens.size.icon,
          ),
          title: Text(
            item.label,
            style: active
                ? tokens.text.titleSmall.copyWith(color: tokens.color.brand)
                : tokens.text.body.copyWith(color: tokens.color.textSecondary),
          ),
        ),
      ),
    );
  }
}
