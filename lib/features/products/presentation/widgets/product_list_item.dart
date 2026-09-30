import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/compact_product_list_row.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/expanded_product_list_row.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({
    required this.product,
    required this.categoryName,
    required this.compact,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Product product;
  final String categoryName;
  final bool compact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final amount = product.salePrice > 0 ? product.salePrice : product.price;
    final formattedPrice = NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      name: l10n.currencyCode,
      decimalDigits: 0,
    ).format(amount);

    final child = compact
        ? CompactProductListRow(
            product: product,
            categoryName: categoryName,
            formattedPrice: formattedPrice,
            onEdit: onEdit,
            onDelete: onDelete,
          )
        : ExpandedProductListRow(
            product: product,
            categoryName: categoryName,
            formattedPrice: formattedPrice,
            onEdit: onEdit,
            onDelete: onDelete,
          );
    final tokens = context.tokens;
    return Container(
      padding: EdgeInsets.all(tokens.space.md),
      decoration: BoxDecoration(
        color: tokens.color.surface,
        borderRadius: BorderRadius.circular(tokens.radius.md),
        border: Border.all(color: tokens.color.border),
      ),
      child: child,
    );
  }
}
