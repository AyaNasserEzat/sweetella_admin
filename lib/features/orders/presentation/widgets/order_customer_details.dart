import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';
import 'package:sweetella_admin/features/orders/presentation/widgets/order_details_section.dart';

class OrderCustomerDetails extends StatelessWidget {
  const OrderCustomerDetails({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      children: [
        OrderDetailsSection(
          title: 'Customer Information',
          icon: Icons.person_outline,
          child: CustomShadowContanier(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderInfoRow(label: 'Name', value: order.customerName),
                OrderInfoRow(label: 'Phone', value: order.phone),
                OrderInfoRow(label: 'Email', value: order.email),
              ],
            ),
          ),
        ),
        SizedBox(height: tokens.space.md),
        CustomShadowContanier(
          child: OrderDetailsSection(
            title: 'Delivery Address',
            icon: Icons.location_on_outlined,
            child: Text(
              order.deliveryAddress.isEmpty
                  ? 'No delivery address'
                  : order.deliveryAddress,
            ),
          ),
        ),
        SizedBox(height: tokens.space.md),
        CustomShadowContanier(
          child: OrderDetailsSection(
            title: 'Customer Notes',
            icon: Icons.notes,
            child: Text(
              order.customerNotes.isEmpty
                  ? 'No customer notes'
                  : order.customerNotes,
            ),
          ),
        ),
      ],
    );
  }
}
