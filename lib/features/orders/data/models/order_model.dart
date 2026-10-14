import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.customerId,
    required super.customerName,
    required super.phone,
    required super.email,
    required super.deliveryAddress,
    required super.customerNotes,
    required super.items,
    required super.status,
    required super.paymentMethod,
    required super.paymentStatus,
    required super.orderType,
    required super.discount,
    required super.deliveryFee,
    required super.createdAt,
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    final rawItems = map['items'] as List? ?? const <dynamic>[];

    return OrderModel(
      id: id,
      customerId: map['customerId']?.toString() ?? '',
      customerName: map['customerName']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      deliveryAddress: map['deliveryAddress']?.toString() ?? '',
      customerNotes: map['customerNotes']?.toString() ?? '',
      items: rawItems.map<OrderItemEntity>((item) {
        final data = Map<String, dynamic>.from(item as Map);

        return OrderItemEntity(
          productId: data['productId']?.toString() ?? '',
          productName: data['productName']?.toString() ?? '',
          imageUrl: data['imageUrl']?.toString() ?? '',
          attributes: data['attributes']?.toString() ?? '',
          quantity: (data['quantity'] as num?)?.toInt() ?? 1,
          unitPrice: (data['unitPrice'] as num?)?.toDouble() ?? 0,
        );
      }).toList(),
      status: OrderStatus.values.firstWhere(
        (value) => value.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentMethod: map['paymentMethod']?.toString() ?? '',
      paymentStatus: map['paymentStatus']?.toString() ?? '',
      orderType: map['orderType']?.toString() ?? 'Delivery',
      discount: (map['discount'] as num?)?.toDouble() ?? 0,
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0,
      createdAt: _parseDate(map['createdAt']),
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    if (value != null) {
      try {
        return value.toDate() as DateTime;
      } catch (_) {
        // Fall through to the default.
      }
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }
}
