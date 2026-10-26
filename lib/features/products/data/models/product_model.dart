import 'package:sweetella_admin/features/products/domain/entities/product.dart';

class ProductModel {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String description;
  final String imageUrl;
  final bool isAvailable;
  final bool hasVariants;
  final bool hasAddons;
  final List<ProductVariantModel> variants;
  final List<ProductAddonModel> addons;
  final double? price;
  final int? stock;
  ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.imageUrl,
    required this.isAvailable,
    required this.hasVariants,
    required this.hasAddons,
    required this.variants,
    required this.addons,
    this.price,
    this.stock,
  });
  ProductModel copyWith({
    String? id,
    String? name,
    String? categoryId,
    String? categoryName,
    String? description,
    String? imageUrl,
    bool? isAvailable,
    bool? hasVariants,
    bool? hasAddons,
    List<ProductVariantModel>? variants,
    List<ProductAddonModel>? addons,
    double? price,
    int? stock,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      hasVariants: hasVariants ?? this.hasVariants,
      hasAddons: hasAddons ?? this.hasAddons,
      variants: variants ?? this.variants,
      addons: addons ?? this.addons,
      price: price ?? this.price,
      stock: stock ?? this.stock,
    );
  }

  // 1. استقبال البيانات من Firebase Firestore (JSON)
  factory ProductModel.fromJson(Map<String, dynamic> json, String docId) {
    return ProductModel(
      id: docId,
      name: json['name'] ?? '',
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      hasVariants: json['hasVariants'] ?? false,
      hasAddons: json['hasAddons'] ?? false,
      variants:
          (json['variants'] as List<dynamic>?)
              ?.map((v) => ProductVariantModel.fromJson(v))
              .toList() ??
          [],
      addons:
          (json['addons'] as List<dynamic>?)
              ?.map((a) => ProductAddonModel.fromJson(a))
              .toList() ??
          [],
      price: (json['price'] as num?)?.toDouble(),
      stock: (json['stock'] as num?)?.toInt(),
    );
  }

  // 2. إرسال البيانات إلى Firebase Firestore (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'description': description,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'hasVariants': hasVariants,
      'hasAddons': hasAddons,
      'variants': variants.map((v) => (v).toJson()).toList(),
      'addons': addons.map((a) => (a).toJson()).toList(),
      'price': price,
      'stock': stock,
    };
  }

  // 3. التحويل من Model إلى Entity (عشان طبقة الـ Domain تستخدمها)
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      imageUrl: imageUrl,
      isAvailable: isAvailable,
      hasVariants: hasVariants,
      hasAddons: hasAddons,
      variants: variants.map((v) => v.toEntity()).toList(),
      addons: addons.map((v) => v.toEntity()).toList(),
      price: price,
      stock: stock,
    );
  }

  // 4. التحويل من Entity إلى Model (عشان نخزنها في Firebase)
  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      description: entity.description,
      imageUrl: entity.imageUrl,
      isAvailable: entity.isAvailable,
      hasVariants: entity.hasVariants,
      hasAddons: entity.hasAddons,
      variants: entity.variants
          .map((v) => ProductVariantModel.fromEntity(v))
          .toList(),
      addons: entity.addons
          .map((a) => ProductAddonModel.fromEntity(a))
          .toList(),
      price: entity.price,
      stock: entity.stock,
    );
  }
}

class ProductVariantModel {
  final String id;
  final String sizeName;
  final double price;
  final int stock;
  ProductVariantModel({
    required this.id,
    required this.sizeName,
    required this.price,
    required this.stock,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] ?? '',
      sizeName: json['sizeName'] ?? '',
      price: (json['price'] as num).toDouble(),
      stock: json['dailyStock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'sizeName': sizeName, 'price': price, 'stock': stock};
  }

  factory ProductVariantModel.fromEntity(ProductVariantEntity entity) {
    return ProductVariantModel(
      id: entity.id,
      sizeName: entity.sizeName,
      price: entity.price,
      stock: entity.stock,
    );
  }
  ProductVariantEntity toEntity() {
    return ProductVariantEntity(
      id: id,
      sizeName: sizeName,
      price: price,
      stock: stock,
    );
  }
}

class ProductAddonModel {
  final String id;
  final String name;
  final double price;
  final int stock;
  ProductAddonModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });

  factory ProductAddonModel.fromJson(Map<String, dynamic> json) {
    return ProductAddonModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price};
  }

  factory ProductAddonModel.fromEntity(ProductAddonEntity entity) {
    return ProductAddonModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      stock: entity.stock,
    );
  }
  ProductAddonEntity toEntity() {
    return ProductAddonEntity(id: id, name: name, price: price, stock: stock);
  }
}
