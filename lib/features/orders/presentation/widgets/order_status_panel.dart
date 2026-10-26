import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';
import 'package:sweetella_admin/features/orders/presentation/widgets/order_details_section.dart';

class OrderStatusPanel extends StatelessWidget {
  const OrderStatusPanel({
    super.key,
    required this.order,
    required this.selectedStatus,
    required this.isUpdating,
    required this.onStatusChanged,
    required this.onUpdateStatus,
  });

  final OrderEntity order;
  final OrderStatus selectedStatus;
  final bool isUpdating;
  final ValueChanged<OrderStatus> onStatusChanged;
  final VoidCallback onUpdateStatus;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      children: [
        OrderDetailsSection(
          title: 'Order Status',
          icon: Icons.local_shipping_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OrderTimeline(status: order.status),
              SizedBox(height: tokens.space.lg),
              Text(
                'Change Status',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: tokens.space.sm),
              DropdownButtonFormField<OrderStatus>(
                initialValue: selectedStatus,
                isExpanded: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: OrderStatus.values.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: isUpdating
                    ? null
                    : (value) {
                        if (value != null) {
                          onStatusChanged(value);
                        }
                      },
              ),
              SizedBox(height: tokens.space.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: isUpdating || selectedStatus == order.status
                      ? null
                      : onUpdateStatus,
                  icon: isUpdating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync),
                  label: const Text('Update Status'),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: tokens.space.md),
        OrderDetailsSection(
          title: 'Payment & Delivery',
          icon: Icons.receipt_long_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderInfoRow(label: 'Order Type', value: order.orderType),
              OrderInfoRow(label: 'Payment Method', value: order.paymentMethod),
              OrderInfoRow(label: 'Payment Status', value: order.paymentStatus),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderTimeline extends StatelessWidget {
  const _OrderTimeline({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final statuses = OrderStatus.values
        .where((item) => item != OrderStatus.cancelled)
        .toList();
    final currentIndex = statuses.indexOf(status);

    return Column(
      children: [
        for (int i = 0; i < statuses.length; i++)
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i <= currentIndex
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  statuses[i].name[0].toUpperCase() +
                      statuses[i].name.substring(1),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
