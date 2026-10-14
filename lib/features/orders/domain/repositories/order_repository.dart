import 'package:dartz/dartz.dart';
import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders();

  Future<Either<Failure, OrderEntity>> getOrderById(String id);

  Future<Either<Failure, Unit>> updateOrderStatus(
    String id,
    OrderStatus status,
  );

  Future<Either<Failure, Unit>> cancelOrder(String id);
}
