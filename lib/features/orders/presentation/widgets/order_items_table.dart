import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';
import 'package:sweetella_admin/core/widgets/custom_table.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';
import 'package:sweetella_admin/features/orders/presentation/widgets/product.dart';

class OrderItemsTable extends StatelessWidget {
  const OrderItemsTable({super.key, required this.items});

  final List<OrderItemEntity> items;

  @override
  Widget build(BuildContext context) {
    return CustomShadowContanier(
      child: CustomTable(
        columnTitles: const ['Product', 'Quantity', 'Unit Price', 'Total'],
        rows: items.map((item) {
          return DataRow(
            cells: [
              DataCell(Product(order: item)),
              DataCell(Text('${item.quantity}')),
              DataCell(Text('${item.unitPrice.toStringAsFixed(0)} EGP')),
              DataCell(Text('${item.total.toStringAsFixed(0)} EGP')),
            ],
          );
        }).toList(),
      ),
    );
  }
}
