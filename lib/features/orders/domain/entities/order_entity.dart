enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  delivered,
  cancelled,
}

class OrderItemEntity {
  const OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.attributes,
    required this.quantity,
    required this.unitPrice,
  });

  final String productId;
  final String productName;
  final String imageUrl;
  final String attributes;
  final int quantity;
  final double unitPrice;

  double get total => quantity * unitPrice;
}

class OrderEntity {
  const OrderEntity({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.phone,
    required this.email,
    required this.deliveryAddress,
    required this.customerNotes,
    required this.items,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderType,
    required this.discount,
    required this.deliveryFee,
    required this.createdAt,
  });

  final String id;
  final String customerId;
  final String customerName;
  final String phone;
  final String email;
  final String deliveryAddress;
  final String customerNotes;
  final List<OrderItemEntity> items;
  final OrderStatus status;
  final String paymentMethod;
  final String paymentStatus;
  final String orderType;
  final double discount;
  final double deliveryFee;
  final DateTime createdAt;

  double get subtotal => items.fold<double>(0, (sum, item) => sum + item.total);

  double get totalAmount => subtotal - discount + deliveryFee;

  OrderEntity copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? phone,
    String? email,
    String? deliveryAddress,
    String? customerNotes,
    List<OrderItemEntity>? items,
    OrderStatus? status,
    String? paymentMethod,
    String? paymentStatus,
    String? orderType,
    double? discount,
    double? deliveryFee,
    DateTime? createdAt,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      customerNotes: customerNotes ?? this.customerNotes,
      items: items ?? this.items,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderType: orderType ?? this.orderType,
      discount: discount ?? this.discount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
