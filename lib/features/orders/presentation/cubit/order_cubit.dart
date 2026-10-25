import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';
import 'package:sweetella_admin/features/orders/domain/repositories/order_repository.dart';
import 'package:sweetella_admin/features/orders/presentation/cubit/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this._repository) : super(const OrderInitial());

  final OrderRepository _repository;

  List<OrderEntity> _orders = const [];
  Future<void> _statusUpdateQueue = Future<void>.value();

  Future<void> loadOrders() async {
    emit(const OrdersLoading());

    final result = await _repository.getOrders();

    result.fold((failure) => emit(OrderFailure(failure)), (orders) {
      _orders = orders;
      emit(OrdersLoaded(orders));
    });
  }

  Future<void> loadOrderDetails(String id) async {
    final result = await _repository.getOrderById(id);

    result.fold(
      (failure) => emit(OrderFailure(failure)),
      (order) => emit(OrderDetailsLoaded(order)),
    );
  }

  Future<void> updateStatus(OrderEntity order, OrderStatus status) async {
    final previousUpdate = _statusUpdateQueue;
    final completer = Completer<void>();
    _statusUpdateQueue = completer.future;

    try {
      await previousUpdate;
      if (isClosed) return;

      final currentOrder = _findOrder(order.id) ?? order;
      emit(OrderActionLoading(currentOrder, _orders));

      final result = await _repository.updateOrderStatus(order.id, status);
      if (isClosed) return;

      result.fold(
        (failure) {
          final latestOrder = _findOrder(order.id) ?? currentOrder;
          emit(OrderActionFailure(latestOrder, failure, _orders));
        },
        (_) {
          final latestOrder = _findOrder(order.id) ?? currentOrder;
          final updatedOrder = latestOrder.copyWith(status: status);
          _orders = _orders.map((item) {
            return item.id == updatedOrder.id ? updatedOrder : item;
          }).toList();
          emit(
            OrderActionSuccess(
              updatedOrder,
              'Order status updated successfully',
              _orders,
            ),
          );
        },
      );
    } finally {
      completer.complete();
    }
  }

  OrderEntity? _findOrder(String id) {
    for (final order in _orders) {
      if (order.id == id) return order;
    }
    return null;
  }

  Future<void> cancelOrder(OrderEntity order) async {
    await updateStatus(order, OrderStatus.cancelled);
  }
}
