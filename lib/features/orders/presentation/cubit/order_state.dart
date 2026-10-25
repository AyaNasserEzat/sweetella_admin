import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';

abstract class OrderState {
  const OrderState();
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrdersLoading extends OrderState {
  const OrdersLoading();
}

class OrdersLoaded extends OrderState {
  const OrdersLoaded(this.orders);

  final List<OrderEntity> orders;
}

class OrderDetailsLoaded extends OrderState {
  const OrderDetailsLoaded(this.order);

  final OrderEntity order;
}

class OrderFailure extends OrderState {
  const OrderFailure(this.error);

  final Failure error;
}

class OrderActionLoading extends OrderState {
  const OrderActionLoading(this.order, this.orders);

  final OrderEntity order;
  final List<OrderEntity> orders;
}

class OrderActionSuccess extends OrderState {
  const OrderActionSuccess(this.order, this.message, this.orders);

  final OrderEntity order;
  final String message;
  final List<OrderEntity> orders;
}

class OrderActionFailure extends OrderState {
  const OrderActionFailure(this.order, this.error, this.orders);

  final OrderEntity order;
  final Failure error;
  final List<OrderEntity> orders;
}
