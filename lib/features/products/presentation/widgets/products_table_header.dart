import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';

class ProductsTableHeader extends StatelessWidget {
  const ProductsTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: tokens.space.md,
        end: tokens.space.md,
        bottom: tokens.space.xs,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(context.l10n.productName, style: tokens.text.label),
          ),
          Expanded(
            flex: 2,
            child: Text(context.l10n.category, style: tokens.text.label),
          ),
          Expanded(
            flex: 2,
            child: Text(context.l10n.price, style: tokens.text.label),
          ),
          Expanded(
            flex: 2,
            child: Text(context.l10n.available, style: tokens.text.label),
          ),
          SizedBox(
            width: tokens.size.profileAvatar * 2,
            child: Text(context.l10n.actions, style: tokens.text.label),
          ),
        ],
      ),
    );
  }
}
