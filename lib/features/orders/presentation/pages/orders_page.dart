import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/di/service_locator.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/error/app_failuer)localization.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';
import 'package:sweetella_admin/features/orders/presentation/cubit/order_cubit.dart';
import 'package:sweetella_admin/features/orders/presentation/cubit/order_state.dart';
import 'package:sweetella_admin/features/orders/presentation/pages/order_details_screen.dart';
import 'package:sweetella_admin/features/orders/presentation/widgets/orders_table.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderCubit>()..loadOrders(),
      child: const _OrdersView(),
    );
  }
}

class _OrdersView extends StatelessWidget {
  const _OrdersView();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(tokens.space.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Orders',
                    style: tokens.text.title.copyWith(
                      color: tokens.color.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: tokens.space.xl),
            Expanded(
              child: BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  if (state is OrdersLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final orders = switch (state) {
                    OrdersLoaded(:final orders) => orders,
                    OrderActionSuccess(:final order) => [order],
                    OrderActionFailure(:final order) => [order],
                    _ => const <OrderEntity>[],
                  };

                  if (state is OrderFailure && orders.isEmpty) {
                    return Center(
                      child: Text(
                        state.error.kind.name,
                        style: tokens.text.body.copyWith(
                          color: tokens.color.danger,
                        ),
                      ),
                    );
                  }

                  if (orders.isEmpty) {
                    print(orders);
                    return Center(
                      child: Text(
                        'No orders found',
                        style: tokens.text.body.copyWith(
                          color: tokens.color.textSecondary,
                        ),
                      ),
                    );
                  }

                  return OrdersTable(
                    orders: orders,
                    onOrderTap: (order) {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => BlocProvider.value(
                            value: context.read<OrderCubit>(),
                            child: OrderDetailsScreen(order: order),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
