import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_actions.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_availability.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_detail.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_image.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_name.dart';

class CompactProductListRow extends StatelessWidget {
  const CompactProductListRow({
    required this.product,
    required this.categoryName,
    required this.formattedPrice,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Product product;
  final String categoryName;
  final String formattedPrice;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            ProductImage(product: product),
            SizedBox(width: tokens.space.md),
            Expanded(child: ProductName(product: product)),
            ProductActions(onEdit: onEdit, onDelete: onDelete),
          ],
        ),
        SizedBox(height: tokens.space.md),
        Wrap(
          spacing: tokens.space.lg,
          runSpacing: tokens.space.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ProductDetail(label: context.l10n.category, value: categoryName),
            ProductDetail(label: context.l10n.price, value: formattedPrice),
            ProductAvailability(product: product),
          ],
        ),
      ],
    );
  }
}
