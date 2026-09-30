import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';

class ProductEmptyState extends StatelessWidget {
  const ProductEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: tokens.color.textSecondary,
            size: tokens.size.icon * 2,
          ),
          SizedBox(height: tokens.space.md),
          Text(context.l10n.productsEmpty, style: tokens.text.titleSmall),
        ],
      ),
    );
  }
}
