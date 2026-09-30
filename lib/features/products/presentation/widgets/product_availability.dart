import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';

class ProductAvailability extends StatelessWidget {
  const ProductAvailability({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final available = product.isAvailable;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.space.sm,
        vertical: tokens.space.xs,
      ),
      decoration: BoxDecoration(
        color: available ? tokens.color.successSoft : tokens.color.dangerSoft,
        borderRadius: BorderRadius.circular(tokens.radius.pill),
      ),
      child: Text(
        available ? context.l10n.available : context.l10n.outOfStock,
        style: tokens.text.chip.copyWith(
          color: available ? tokens.color.success : tokens.color.danger,
        ),
      ),
    );
  }
}
