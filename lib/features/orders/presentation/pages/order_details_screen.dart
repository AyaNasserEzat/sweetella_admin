import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/error/app_failuer)localization.dart';
import 'package:sweetella_admin/core/widgets/custom_overlay_message.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';
import 'package:sweetella_admin/core/widgets/custom_table.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';
import 'package:sweetella_admin/features/orders/presentation/cubit/order_cubit.dart';
import 'package:sweetella_admin/features/orders/presentation/cubit/order_state.dart';
import 'package:sweetella_admin/features/orders/presentation/widgets/order_status_badge.dart';
import 'package:sweetella_admin/features/orders/presentation/widgets/product.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final OrderEntity order;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late OrderStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderActionSuccess && state.order.id == widget.order.id) {
          setState(() => _selectedStatus = state.order.status);
          showOverlayMessage(context: context, text: state.message);
          return;
        }

        if (state is OrderActionFailure && state.order.id == widget.order.id) {
          showOverlayMessage(
            context: context,
            text: state.error.message(context),
          );
        }
      },
      builder: (context, state) {
        final order = switch (state) {
          OrderDetailsLoaded(:final order) => order,
          OrderActionLoading(:final order) when order.id == widget.order.id =>
            order,
          OrderActionSuccess(:final order) when order.id == widget.order.id =>
            order,
          OrderActionFailure(:final order) when order.id == widget.order.id =>
            order,
          _ => widget.order,
        };

        final isUpdating =
            state is OrderActionLoading && state.order.id == widget.order.id;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(tokens.space.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to Orders'),
                  ),
                  SizedBox(height: tokens.space.md),
                  Wrap(
                    spacing: tokens.space.md,
                    runSpacing: tokens.space.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      OrderStatusBadge(status: order.status),
                    ],
                  ),
                  SizedBox(height: tokens.space.xs),
                  Text(
                    '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year} • '
                    '${order.createdAt.hour.toString().padLeft(2, '0')}:${order.createdAt.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: tokens.space.lg),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 900;

                      final details = Column(
                        children: [
                          _Section(
                            title: 'Customer Information',
                            icon: Icons.person_outline,
                            child: CustomShadowContanier(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _InfoRow(
                                    label: 'Name',
                                    value: order.customerName,
                                  ),
                                  _InfoRow(label: 'Phone', value: order.phone),
                                  _InfoRow(label: 'Email', value: order.email),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: tokens.space.md),
                          CustomShadowContanier(
                            child: _Section(
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
                            child: _Section(
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

                      final statusPanel = Column(
                        children: [
                          _Section(
                            title: 'Order Status',
                            icon: Icons.local_shipping_outlined,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _OrderTimeline(status: order.status),
                                SizedBox(height: tokens.space.lg),
                                Text(
                                  'Change Status',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                SizedBox(height: tokens.space.sm),
                                DropdownButtonFormField<OrderStatus>(
                                  initialValue: _selectedStatus,
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
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
                                            setState(
                                              () => _selectedStatus = value,
                                            );
                                          }
                                        },
                                ),
                                SizedBox(height: tokens.space.md),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed:
                                        isUpdating ||
                                            _selectedStatus == order.status
                                        ? null
                                        : () {
                                            context
                                                .read<OrderCubit>()
                                                .updateStatus(
                                                  order,
                                                  _selectedStatus,
                                                );
                                          },
                                    icon: isUpdating
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(Icons.sync),
                                    label: const Text('Update Status'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: tokens.space.md),
                          _Section(
                            title: 'Payment & Delivery',
                            icon: Icons.receipt_long_outlined,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _InfoRow(
                                  label: 'Order Type',
                                  value: order.orderType,
                                ),
                                _InfoRow(
                                  label: 'Payment Method',
                                  value: order.paymentMethod,
                                ),
                                _InfoRow(
                                  label: 'Payment Status',
                                  value: order.paymentStatus,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );

                      if (wide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: details),
                            SizedBox(width: tokens.space.lg),
                            Expanded(flex: 1, child: statusPanel),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          details,
                          SizedBox(height: tokens.space.md),
                          statusPanel,
                        ],
                      );
                    },
                  ),
                  SizedBox(height: tokens.space.lg),
                  OrderItemsTable(items: order.items),

                  SizedBox(height: tokens.space.lg),
                  _Section(
                    title: 'Summary',
                    icon: Icons.summarize_outlined,
                    child: Column(
                      children: [
                        _InfoRow(
                          label: 'Subtotal',
                          value: '${order.subtotal.toStringAsFixed(0)} EGP',
                        ),
                        _InfoRow(
                          label: 'Discount',
                          value: '-${order.discount.toStringAsFixed(0)} EGP',
                        ),
                        _InfoRow(
                          label: 'Delivery Fee',
                          value: '${order.deliveryFee.toStringAsFixed(0)} EGP',
                        ),
                        Divider(height: tokens.space.lg),
                        _InfoRow(
                          label: 'Total',
                          value: '${order.totalAmount.toStringAsFixed(0)} EGP',
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tokens.space.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(tokens.radius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              SizedBox(width: tokens.space.sm),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          SizedBox(height: tokens.space.md),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
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
