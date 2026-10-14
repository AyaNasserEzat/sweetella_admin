import 'package:flutter/material.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/custom_cached_network_image.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';

class Product extends StatelessWidget {
  const Product({super.key, required this.order});
  final OrderItemEntity order;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        CustomCachedNetworkImage(imageUrl: order.imageUrl),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(order.productName.isEmpty ? "no" : order.productName),
            Text(order.attributes.isNotEmpty ? order.attributes : '-'),
          ],
        ),
      ],
    );
  }
}
