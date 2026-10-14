import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';
import 'package:sweetella_admin/features/orders/domain/repositories/order_repository.dart';
import 'package:sweetella_admin/features/orders/presentation/cubit/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this._repository) : super(const OrderInitial());

  final OrderRepository _repository;

  List<OrderEntity> _orders = const [];

  Future<void> loadOrders() async {
    emit(const OrdersLoading());

    final result = await _repository.getOrders();

    result.fold(
      (failure) => emit(OrderFailure(failure)),
      (orders) {
        _orders = orders;
        emit(OrdersLoaded(orders));
      },
    );
  }

  Future<void> loadOrderDetails(String id) async {
    final result = await _repository.getOrderById(id);

    result.fold(
      (failure) => emit(OrderFailure(failure)),
      (order) => emit(OrderDetailsLoaded(order)),
    );
  }

  Future<void> updateStatus(OrderEntity order, OrderStatus status) async {
    emit(OrderActionLoading(order));

    final result = await _repository.updateOrderStatus(order.id, status);

    result.fold(
      (failure) => emit(OrderActionFailure(order, failure)),
      (_) {
        final updatedOrder = order.copyWith(status: status);
        _orders = _orders.map((item) {
          return item.id == updatedOrder.id ? updatedOrder : item;
        }).toList();
        emit(OrderActionSuccess(updatedOrder, 'Order status updated successfully'));
      },
    );
  }

  Future<void> cancelOrder(OrderEntity order) async {
    await updateStatus(order, OrderStatus.cancelled);
  }
}
