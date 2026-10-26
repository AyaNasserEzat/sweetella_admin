import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';
import 'package:sweetella_admin/features/orders/presentation/widgets/order_details_section.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return OrderDetailsSection(
      title: 'Summary',
      icon: Icons.summarize_outlined,
      child: Column(
        children: [
          OrderInfoRow(
            label: 'Subtotal',
            value: '${order.subtotal.toStringAsFixed(0)} EGP',
          ),
          OrderInfoRow(
            label: 'Discount',
            value: '-${order.discount.toStringAsFixed(0)} EGP',
          ),
          OrderInfoRow(
            label: 'Delivery Fee',
            value: '${order.deliveryFee.toStringAsFixed(0)} EGP',
          ),
          Divider(height: tokens.space.lg),
          OrderInfoRow(
            label: 'Total',
            value: '${order.totalAmount.toStringAsFixed(0)} EGP',
            bold: true,
          ),
        ],
      ),
    );
  }
}
