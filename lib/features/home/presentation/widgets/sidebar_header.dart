import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class SidebarHeader extends StatelessWidget {
  const SidebarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: tokens.size.profileAvatar,
          height: tokens.size.profileAvatar,
          decoration: BoxDecoration(
            color: tokens.color.brandSoft,
            borderRadius: BorderRadius.circular(tokens.radius.xl),
          ),
          child: Center(
            child: Icon(
              Icons.cake_rounded,
              color: tokens.color.brand,
              size: tokens.size.icon,
            ),
          ),
        ),

        SizedBox(width: tokens.space.md),
        Flexible(
          child: Text(
            'Sweetella',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tokens.text.title,
          ),
        ),
      ],
    );
  }
}
