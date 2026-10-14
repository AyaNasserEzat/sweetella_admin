import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';
import 'package:sweetella_admin/core/widgets/custom_table.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';
import 'package:sweetella_admin/features/orders/presentation/widgets/order_status_badge.dart';

class OrdersTable extends StatelessWidget {
  const OrdersTable({
    super.key,
    required this.orders,
    required this.onOrderTap,
  });

  final List<OrderEntity> orders;
  final ValueChanged<OrderEntity> onOrderTap;

  @override
  Widget build(BuildContext context) {
    return CustomShadowContanier(
      child: CustomTable(
        columnTitles: const [
          'Order ID',
          'Customer',
          'Date',
          'Items',
          'Total',
          'Status',
          'Action',
        ],
        rows: orders.map((order) {
          return DataRow(
            cells: [
              DataCell(
                Text('#${order.id}'),
                onTap: () => onOrderTap(order),
              ),
              DataCell(
                Text(order.customerName),
                onTap: () => onOrderTap(order),
              ),
              DataCell(
                Text(
                  '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                ),
                onTap: () => onOrderTap(order),
              ),
              DataCell(
                Text('${order.items.length}'),
                onTap: () => onOrderTap(order),
              ),
              DataCell(
                Text('${order.totalAmount.toStringAsFixed(0)} EGP'),
                onTap: () => onOrderTap(order),
              ),
              DataCell(
                OrderStatusBadge(status: order.status),
                onTap: () => onOrderTap(order),
              ),
              DataCell(
                IconButton(
                  tooltip: 'View order',
                  icon: const Icon(Icons.visibility_outlined),
                  onPressed: () => onOrderTap(order),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
