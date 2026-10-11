import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';
import 'package:sweetella_admin/core/widgets/custom_table.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/custom_cached_network_image.dart';
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
              DataCell(Text(product.name.toString())),
              DataCell(Text(product.categoryName)),
              DataCell(Text(product.price.toString())),
              DataCell(ProductAvailability(product: product)),
              DataCell(ProductActions(onEdit: () {}, onDelete: () {})),
            ],
          );
        }).toList(),
      ),
    );
  }
}
