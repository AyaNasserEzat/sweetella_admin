import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sweetella_admin/core/services/firebase_service.dart';
import 'package:sweetella_admin/features/orders/data/models/order_model.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders();

  Future<OrderModel> getOrderById(String id);

  Future<void> updateOrderStatus(String id, String status);

  Future<void> cancelOrder(String id);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  const OrderRemoteDataSourceImpl(this._firebaseServices);

  static const _collectionName = 'orders';

  final FirebaseServices _firebaseServices;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firebaseServices.firestore.collection(_collectionName);

  @override
  Future<List<OrderModel>> getOrders() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .get();

    debugPrint('Orders count: ${snapshot.docs.length}');

    for (final doc in snapshot.docs) {
      debugPrint('Order ID: ${doc.id}');
      debugPrint('Order data: ${doc.data()}');
    }

    return snapshot.docs
        .map((doc) => OrderModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    final doc = await _orders.doc(id).get();

    if (!doc.exists || doc.data() == null) {
      throw StateError('Order not found');
    }

    return OrderModel.fromMap(doc.id, doc.data()!);
  }

  @override
  Future<void> updateOrderStatus(String id, String status) async {
    await _orders.doc(id).update({'status': status});
  }

  @override
  Future<void> cancelOrder(String id) async {
    await updateOrderStatus(id, OrderStatus.cancelled.name);
  }
}
