import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_actions.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_availability.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_image.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_name.dart';

class ExpandedProductListRow extends StatelessWidget {
  const ExpandedProductListRow({
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
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Row(
            children: [
              ProductImage(product: product),
              SizedBox(width: tokens.space.md),
              Expanded(child: ProductName(product: product)),
            ],
          ),
        ),
        Expanded(flex: 2, child: Text(categoryName, style: tokens.text.body)),
        Expanded(
          flex: 2,
          child: Text(formattedPrice, style: tokens.text.amount),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: ProductAvailability(product: product),
          ),
        ),
        ProductActions(onEdit: onEdit, onDelete: onDelete),
      ],
    );
  }
}
