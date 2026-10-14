import 'package:dartz/dartz.dart';
import 'package:sweetella_admin/core/error/exception_handelr.dart';
import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';
import 'package:sweetella_admin/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(this._remoteDataSource);

  final OrderRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    try {
      final orders = await _remoteDataSource.getOrders();
      return Right(orders);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String id) async {
    try {
      final order = await _remoteDataSource.getOrderById(id);
      return Right(order);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateOrderStatus(
    String id,
    OrderStatus status,
  ) async {
    try {
      await _remoteDataSource.updateOrderStatus(id, status.name);
      return const Right(unit);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelOrder(String id) async {
    try {
      await _remoteDataSource.cancelOrder(id);
      return const Right(unit);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
