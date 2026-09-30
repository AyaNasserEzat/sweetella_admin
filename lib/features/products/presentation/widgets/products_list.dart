import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/core/layout/breakpoints.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_list_item.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/products_table_header.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({
    required this.products,
    required this.categories,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final List<Product> products;
  final List<ProductCategory> categories;
  final ValueChanged<Product> onEdit;
  final ValueChanged<Product> onDelete;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact =
            AppBreakpoints.fromWidth(constraints.maxWidth) ==
            AppBreakpoint.compact;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!compact) ...[
              const ProductsTableHeader(),
              SizedBox(height: tokens.space.sm),
            ],
            Expanded(
              child: ListView.separated(
                itemCount: products.length,
                padding: EdgeInsets.only(bottom: tokens.space.xl),
                separatorBuilder: (context, index) =>
                    SizedBox(height: tokens.space.sm),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final category = categories
                      .where((item) => item.id == product.categoryId)
                      .firstOrNull;
                  return ProductListItem(
                    key: ValueKey(product.id),
                    product: product,
                    categoryName:
                        category?.name ?? context.l10n.unknownCategory,
                    compact: compact,
                    onEdit: () => onEdit(product),
                    onDelete: () => onDelete(product),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
