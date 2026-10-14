import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';
import 'package:sweetella_admin/core/widgets/custom_table.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/custom_cached_network_image.dart';
import 'package:sweetella_admin/features/orders/presentation/widgets/product.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_actions.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_availability.dart';

class ProductsTable extends StatelessWidget {
  final List<ProductEntity> products;

  const ProductsTable({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return CustomShadowContanier(
      child: CustomTable(
        columnTitles: const [
          'Image',
          'name',
          'Category',
          'Price',
          'avilable',
          'Action',
        ],
        rows: products.map((product) {
          return DataRow(
            cells: [
              DataCell(CustomCachedNetworkImage(imageUrl: product.imageUrl)),
              DataCell(Text(product.name)),
              DataCell(Text(product.categoryName)),
              DataCell(Text(product.price.toString())),
              DataCell(ProductAvailability(product: product)),
              DataCell(
                ProductActions(
                  onEdit: () {},
                  onDelete: () {
                    _confirmDelete(context, product);
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

Future<void> _confirmDelete(BuildContext context, ProductEntity product) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.deleteProductTitle),
      content: Text(l10n.deleteProductMessage(product)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.deleteProduct),
        ),
      ],
    ),
  );
  if (confirmed == true && context.mounted) {
    //  await context.read<ProductCubit>().delete(product.id);
  }
}
