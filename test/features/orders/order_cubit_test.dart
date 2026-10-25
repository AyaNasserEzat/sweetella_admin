import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';
import 'package:sweetella_admin/features/orders/domain/repositories/order_repository.dart';
import 'package:sweetella_admin/features/orders/presentation/cubit/order_cubit.dart';
import 'package:sweetella_admin/features/orders/presentation/cubit/order_state.dart';

void main() {
  final firstOrder = _order('first');
  final secondOrder = _order('second');

  test(
    'updates one order and emits the complete list without refetching',
    () async {
      final repository = _FakeOrderRepository([
        firstOrder,
        secondOrder,
      ], const Right(unit));
      final cubit = OrderCubit(repository);
      addTearDown(cubit.close);
      await cubit.loadOrders();

      final emittedStates = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<OrderActionLoading>().having((state) => state.orders, 'orders', [
            firstOrder,
            secondOrder,
          ]),
          isA<OrderActionSuccess>()
              .having(
                (state) => state.order.status,
                'updated status',
                OrderStatus.confirmed,
              )
              .having(
                (state) => state.orders.map((order) => order.status).toList(),
                'all order statuses',
                [OrderStatus.confirmed, OrderStatus.pending],
              ),
        ]),
      );

      await cubit.updateStatus(firstOrder, OrderStatus.confirmed);
      await emittedStates;

      expect(repository.getOrdersCalls, 1);
    },
  );

  test('preserves all orders when updating status fails', () async {
    final failure = Failure(FailureKind.server);
    final repository = _FakeOrderRepository([
      firstOrder,
      secondOrder,
    ], Left(failure));
    final cubit = OrderCubit(repository);
    addTearDown(cubit.close);
    await cubit.loadOrders();

    final emittedStates = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<OrderActionLoading>().having((state) => state.orders, 'orders', [
          firstOrder,
          secondOrder,
        ]),
        isA<OrderActionFailure>()
            .having((state) => state.error, 'failure', same(failure))
            .having((state) => state.orders, 'orders', [
              firstOrder,
              secondOrder,
            ]),
      ]),
    );

    await cubit.updateStatus(firstOrder, OrderStatus.confirmed);
    await emittedStates;
  });
}

OrderEntity _order(String id) {
  return OrderEntity(
    id: id,
    customerId: 'customer-$id',
    customerName: 'Customer $id',
    phone: '',
    email: '',
    deliveryAddress: '',
    customerNotes: '',
    items: const [],
    status: OrderStatus.pending,
    paymentMethod: '',
    paymentStatus: '',
    orderType: '',
    discount: 0,
    deliveryFee: 0,
    createdAt: DateTime(2025),
  );
}

class _FakeOrderRepository implements OrderRepository {
  _FakeOrderRepository(this.orders, this.updateResult);

  final List<OrderEntity> orders;
  final Either<Failure, Unit> updateResult;
  var getOrdersCalls = 0;

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    getOrdersCalls++;
    return Right(orders);
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String id) async {
    return Left(Failure(FailureKind.notFound));
  }

  @override
  Future<Either<Failure, Unit>> updateOrderStatus(
    String id,
    OrderStatus status,
  ) async {
    return updateResult;
  }

  @override
  Future<Either<Failure, Unit>> cancelOrder(String id) async {
    return const Right(unit);
  }
}
