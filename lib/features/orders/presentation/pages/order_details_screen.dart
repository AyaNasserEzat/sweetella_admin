import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/error/app_failuer)localization.dart';
import 'package:sweetella_admin/core/widgets/custom_overlay_message.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';
import 'package:sweetella_admin/features/orders/presentation/cubit/order_cubit.dart';
import 'package:sweetella_admin/features/orders/presentation/cubit/order_state.dart';
import 'package:sweetella_admin/features/orders/presentation/widgets/order_customer_details.dart';
import 'package:sweetella_admin/features/orders/presentation/widgets/order_details_header.dart';
import 'package:sweetella_admin/features/orders/presentation/widgets/order_items_table.dart';
import 'package:sweetella_admin/features/orders/presentation/widgets/order_status_panel.dart';
import 'package:sweetella_admin/features/orders/presentation/widgets/order_summary.dart';

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
                  OrderDetailsHeader(
                    order: order,
                    onBack: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(height: tokens.space.lg),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 900;
                      final customerDetails = OrderCustomerDetails(
                        order: order,
                      );
                      final statusPanel = OrderStatusPanel(
                        order: order,
                        selectedStatus: _selectedStatus,
                        isUpdating: isUpdating,
                        onStatusChanged: (status) {
                          setState(() => _selectedStatus = status);
                        },
                        onUpdateStatus: () {
                          context.read<OrderCubit>().updateStatus(
                            order,
                            _selectedStatus,
                          );
                        },
                      );

                      if (wide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: customerDetails),
                            SizedBox(width: tokens.space.lg),
                            Expanded(flex: 1, child: statusPanel),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          customerDetails,
                          SizedBox(height: tokens.space.md),
                          statusPanel,
                        ],
                      );
                    },
                  ),
                  SizedBox(height: tokens.space.lg),
                  OrderItemsTable(items: order.items),
                  SizedBox(height: tokens.space.lg),
                  OrderSummary(order: order),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
