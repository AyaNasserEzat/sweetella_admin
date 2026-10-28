// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sweetella_admin/core/di/service_locator.dart';
// import 'package:sweetella_admin/core/design/app_tokens.dart';
// import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';
// import 'package:sweetella_admin/features/orders/presentation/cubit/order_cubit.dart';
// import 'package:sweetella_admin/features/orders/presentation/cubit/order_state.dart';
// import 'package:sweetella_admin/features/orders/presentation/pages/order_details_screen.dart';
// import 'package:sweetella_admin/features/orders/presentation/widgets/orders_table.dart';

// class OrdersPage extends StatelessWidget {
//   const OrdersPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => sl<OrderCubit>()..loadOrders(),
//       child: const _OrdersView(),
//     );
//   }
// }

// class _OrdersView extends StatelessWidget {
//   const _OrdersView();

//   @override
//   Widget build(BuildContext context) {
//     final tokens = context.tokens;

//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(tokens.space.xl),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     'Orders',
//                     style: tokens.text.title.copyWith(
//                       color: tokens.color.textPrimary,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: tokens.space.xl),
//             Expanded(
//               child: BlocBuilder<OrderCubit, OrderState>(
//                 builder: (context, state) {
//                   if (state is OrdersLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   final orders = switch (state) {
//                     OrdersLoaded(:final orders) => orders,
//                     OrderActionLoading(:final orders) => orders,
//                     OrderActionSuccess(:final orders) => orders,
//                     OrderActionFailure(:final orders) => orders,
//                     _ => const <OrderEntity>[],
//                   };

//                   if (state is OrderFailure && orders.isEmpty) {
//                     return Center(
//                       child: Text(
//                         state.error.kind.name,
//                         style: tokens.text.body.copyWith(
//                           color: tokens.color.danger,
//                         ),
//                       ),
//                     );
//                   }

//                   if (orders.isEmpty) {
//                     return Center(
//                       child: Text(
//                         'No orders found',
//                         style: tokens.text.body.copyWith(
//                           color: tokens.color.textSecondary,
//                         ),
//                       ),
//                     );
//                   }

//                   return OrdersTable(
//                     orders: orders,
//                     onOrderTap: (order) {
//                       Navigator.of(context).push(
//                         MaterialPageRoute<void>(
//                           builder: (_) => BlocProvider.value(
//                             value: context.read<OrderCubit>(),
//                             child: OrderDetailsScreen(order: order),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/di/service_locator.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
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

class _OrdersView extends StatefulWidget {
  const _OrdersView();

  @override
  State<_OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<_OrdersView> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  OrderStatus? _selectedStatus;

  static const Map<OrderStatus, String> _statusLabels = {
    OrderStatus.pending: 'Pending',
    OrderStatus.confirmed: 'Confirmed',
    OrderStatus.preparing: 'Preparing',
    OrderStatus.ready: 'Ready',
    OrderStatus.delivered: 'Delivered',
    OrderStatus.cancelled: 'Cancelled',
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<OrderEntity> _filterOrders(List<OrderEntity> orders) {
    final query = _searchQuery.trim().toLowerCase();

    return orders.where((order) {
      final matchesStatus =
          _selectedStatus == null || order.status == _selectedStatus;

      final matchesSearch =
          query.isEmpty ||
          order.customerName.toLowerCase().contains(query) ||
          order.id.toLowerCase().contains(query) ||
          order.status.name.toLowerCase().contains(query);

      return matchesStatus && matchesSearch;
    }).toList();
  }

  void _openOrderDetails(OrderEntity order) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<OrderCubit>(),
          child: OrderDetailsScreen(order: order),
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required BuildContext context,
    required String title,
    required int count,
    required bool selected,
    required VoidCallback onTap,
    required AppTokens tokens,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.all(tokens.space.lg),
            decoration: BoxDecoration(
              color: selected
                  ? tokens.color.brand
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tokens.text.body.copyWith(
                          color: selected
                              ? Colors.white
                              : tokens.color.textSecondary,
                        ),
                      ),
                    ),
                    if (selected) ...[
                      SizedBox(width: tokens.space.xs),
                      const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: tokens.space.sm),
                Text(
                  '$count',
                  style: tokens.text.title.copyWith(
                    color: selected ? Colors.white : tokens.color.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCards({
    required BuildContext context,
    required List<OrderEntity> orders,
    required AppTokens tokens,
    required double cardWidth,
  }) {
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: OrderStatus.values.length + 1,
        separatorBuilder: (_, _) => SizedBox(width: tokens.space.md),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildStatusCard(
              context: context,
              title: 'All Orders',
              count: orders.length,
              selected: _selectedStatus == null,
              onTap: () => setState(() => _selectedStatus = null),
              tokens: tokens,
              width: cardWidth,
            );
          }

          final status = OrderStatus.values[index - 1];
          final count = orders.where((order) => order.status == status).length;

          return _buildStatusCard(
            context: context,
            title: _statusLabels[status]!,
            count: count,
            selected: _selectedStatus == status,
            onTap: () => setState(() => _selectedStatus = status),
            tokens: tokens,
            width: cardWidth,
          );
        },
      ),
    );
  }

  Widget _buildSearchField({required bool isCompact}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isCompact ? double.infinity : 520),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
        decoration: InputDecoration(
          hintText: 'Search by customer, order ID, or status',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  tooltip: 'Clear search',
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildError(String message, AppTokens tokens) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: tokens.text.body.copyWith(color: tokens.color.danger),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 600;
            final horizontalPadding = isCompact
                ? tokens.space.md
                : tokens.space.xl;
            final cardWidth = isCompact ? 145.0 : 165.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: tokens.space.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Orders',
                    style: tokens.text.title.copyWith(
                      color: tokens.color.textPrimary,
                    ),
                  ),
                  SizedBox(height: tokens.space.xl),

                  _buildSearchField(isCompact: isCompact),

                  SizedBox(height: tokens.space.lg),

                  BlocBuilder<OrderCubit, OrderState>(
                    builder: (context, state) {
                      if (state is OrdersLoading) {
                        return const SizedBox(
                          height: 250,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final orders = switch (state) {
                        OrdersLoaded(:final orders) => orders,
                        OrderActionLoading(:final orders) => orders,
                        OrderActionSuccess(:final orders) => orders,
                        OrderActionFailure(:final orders) => orders,
                        _ => const <OrderEntity>[],
                      };

                      if (state is OrderFailure && orders.isEmpty) {
                        return _buildError(state.error.kind.name, tokens);
                      }

                      if (orders.isEmpty) {
                        return SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(
                              'No orders found',
                              style: tokens.text.body.copyWith(
                                color: tokens.color.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }

                      final filteredOrders = _filterOrders(orders);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatusCards(
                            context: context,
                            orders: orders,
                            tokens: tokens,
                            cardWidth: cardWidth,
                          ),

                          SizedBox(height: tokens.space.lg),

                          Text(
                            'Showing ${filteredOrders.length} '
                            'of ${orders.length} orders',
                            style: tokens.text.body.copyWith(
                              color: tokens.color.textSecondary,
                            ),
                          ),

                          SizedBox(height: tokens.space.md),

                          if (filteredOrders.isEmpty)
                            const SizedBox(
                              height: 200,
                              child: Center(
                                child: Text('No matching orders found'),
                              ),
                            )
                          else
                            SizedBox(
                              width: double.infinity,
                              child: OrdersTable(
                                orders: filteredOrders,
                                onOrderTap: _openOrderDetails,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
