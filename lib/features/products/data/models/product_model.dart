// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:sweetella_admin/features/products/domain/entities/product.dart';

// class ProductModel {
//   const ProductModel({
//     required this.id,
//     required this.name,
//     required this.categoryId,
//     required this.categoryName,
//     required this.description,
//     required this.price,
//     required this.salePrice,
//     required this.imageUrl,
//     required this.attributes,
//   });

//   factory ProductModel.fromSnapshot(
//     DocumentSnapshot<Map<String, dynamic>> document,
//   ) {
//     final data = document.data();
//     if (data == null) {
//       throw FormatException('Product ${document.id} has no data.');
//     }

//     final rawAttributes = data['attributes'] as List<dynamic>? ?? const [];
//     return ProductModel(
//       id: document.id,
//       name: data['name'] as String? ?? '',
//       categoryId: data['categoryId'] as String? ?? '',
//       categoryName: data['categoryName'] as String? ?? '',
//       description: data['description'] as String? ?? '',
//       price: (data['price'] as num?)?.toInt() ?? 0,
//       salePrice: (data['salePrice'] as num?)?.toInt() ?? 0,
//       imageUrl: data['imageUrl'] as String? ?? '',
//       attributes: rawAttributes
//           .map((attribute) {
//             final attributeData = Map<String, dynamic>.from(attribute as Map);
//             final rawOptions =
//                 attributeData['options'] as List<dynamic>? ?? const [];
//             return ProductAttribute(
//               title: attributeData['title'] as String? ?? '',
//               options: rawOptions
//                   .map((option) {
//                     final optionData = Map<String, dynamic>.from(option as Map);
//                     return ProductOption(
//                       value: optionData['value'] as String? ?? '',
//                       priceModifier:
//                           (optionData['price_modifier'] as num?)?.toDouble() ??
//                           0,
//                       stock: (optionData['stock'] as num?)?.toInt() ?? 0,
//                     );
//                   })
//                   .toList(growable: false),
//             );
//           })
//           .toList(growable: false),
//     );
//   }

//   factory ProductModel.fromEntity(ProductEntity product) {
//     return ProductModel(
//       id: product.id,
//       name: product.name,
//       categoryId: product.categoryId,
//       categoryName: product.categoryName,
//       description: product.description,
//       price: product.price,
//       salePrice: product.salePrice,
//       imageUrl: product.imageUrl,
//       attributes: product.attributes,
//     );
//   }

//   final String id;
//   final String name;
//   final String categoryId;
//   final String categoryName;
//   final String description;
//   final int price;
//   final int salePrice;
//   final String imageUrl;
//   final List<ProductAttribute> attributes;

//   ProductEntity toEntity() {
//     return ProductEntity(
//       id: id,
//       name: name,
//       categoryId: categoryId,
//       categoryName: categoryName,
//       description: description,
//       price: price,
//       salePrice: salePrice,
//       imageUrl: imageUrl,
//       attributes: attributes,
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       'id': id,
//       'categoryId': categoryId,
//       'categoryName': categoryName,
//       'name': name,
//       'description': description,
//       'price': price,
//       'imageUrl': imageUrl,
//       'salePrice': salePrice,
//       'attributes': attributes
//           .map(
//             (attribute) => {
//               'title': attribute.title,
//               'options': attribute.options
//                   .map(
//                     (option) => {
//                       'value': option.value,
//                       'price_modifier': option.priceModifier,
//                       'stock': option.stock,
//                     },
//                   )
//                   .toList(growable: false),
//             },
//           )
//           .toList(growable: false),
//     };
//   }
// }
// lib/features/products/domain/entities/product_variant.dart
import 'package:sweetella_admin/features/products/domain/entities/product.dart';

// class ProductVariant {
//   final String id;
//   final String sizeName; // مثل: قطعة واحدة / صغير / 1 كيلو
//   final double price;
//   final int dailyStock;

//   ProductVariant({
//     required this.id,
//     required this.sizeName,
//     required this.price,
//     required this.dailyStock,
//   });

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'sizeName': sizeName,
//     'price': price,
//     'dailyStock': dailyStock,
//   };

//   factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
//     id: json['id'] ?? '',
//     sizeName: json['sizeName'] ?? '',
//     price: (json['price'] as num).toDouble(),
//     dailyStock: json['dailyStock'] ?? 0,
//   );
// }

// // lib/features/products/domain/entities/product_addon.dart
// class ProductAddon {
//   final String id;
//   final String name; // مثل: صوص شوكولاتة إضافي
//   final double price;

//   ProductAddon({required this.id, required this.name, required this.price});

//   Map<String, dynamic> toJson() => {'id': id, 'name': name, 'price': price};

//   factory ProductAddon.fromJson(Map<String, dynamic> json) => ProductAddon(
//     id: json['id'] ?? '',
//     name: json['name'] ?? '',
//     price: (json['price'] as num).toDouble(),
//   );
// }

// // lib/features/products/domain/entities/product_entity.dart
// class ProductModel {
//   final String id;
//   final String name;
//   final String categoryId;
//   final String categoryName;
//   final String description;
//   final String imageUrl;
//   final bool isAvailable;
//   final bool hasVariants;
//   final bool hasAddons;
//   final List<ProductVariant> variants;
//   final List<ProductAddon> addons;

//   ProductModel({
//     required this.id,
//     required this.name,
//     required this.categoryId,
//     required this.categoryName,
//     required this.description,
//     required this.imageUrl,
//     required this.isAvailable,
//     required this.hasVariants,
//     required this.hasAddons,
//     required this.variants,
//     required this.addons,
//   });

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'category': categoryId,
//     'categoryName': categoryName,
//     'description': description,
//     'imageUrl': imageUrl,
//     'isAvailable': isAvailable,
//     'hasVariants': hasVariants,
//     'hasAddons': hasAddons,
//     'variants': variants.map((v) => v.toJson()).toList(),
//     'addons': addons.map((a) => a.toJson()).toList(),
//   };
//   factory ProductModel.fromEntity(ProductEntity entity) {
//     return ProductModel(
//       id: entity.id,
//       name: entity.name,
//       categoryId: entity.categoryId,
//       categoryName: entity.categoryName,
//       description: entity.description,
//       imageUrl: entity.imageUrl,
//       isAvailable: entity.isAvailable,
//       hasVariants: entity.hasVariants,
//       hasAddons: entity.hasAddons,
//       variants: entity.variants
//           .map(
//             (variantEntity) => ProductVariant(
//               id: variantEntity.id,
//               sizeName: variantEntity.sizeName,
//               price: variantEntity.price,
//               dailyStock: variantEntity.stock,
//             ),
//           )
//           .toList(),
//       addons: entity.addons
//           .map(
//             (addonEntity) => ProductAddon(
//               id: addonEntity.id,
//               name: addonEntity.name,
//               price: addonEntity.price,
//             ),
//           )
//           .toList(),
//     );
//   }
//   ProductEntity toEntity() {
//     return ProductEntity(
//       id: id,
//       name: name,
//       categoryId: categoryId,
//       categoryName: categoryName,
//       description: description,
//       imageUrl: imageUrl,
//       isAvailable: isAvailable,
//       hasVariants: hasVariants,
//       hasAddons: hasAddons,
//       variants: variants,
//       addons: addons,
//     );
//   }

//   factory ProductModel.fromJson(Map<String, dynamic> json, String docId) =>
//       ProductModel(
//         id: docId,
//         name: json['name'] ?? '',
//         categoryId: json['category'] ?? '',
//         categoryName: json['categoryName'] ?? '',
//         description: json['description'] ?? '',
//         imageUrl: json['imageUrl'] ?? '',
//         isAvailable: json['isAvailable'] ?? true,
//         hasVariants: json['hasVariants'] ?? false,
//         hasAddons: json['hasAddons'] ?? false,
//         variants:
//             (json['variants'] as List<dynamic>?)
//                 ?.map((v) => ProductVariant.fromJson(v))
//                 .toList() ??
//             [],
//         addons:
//             (json['addons'] as List<dynamic>?)
//                 ?.map((a) => ProductAddon.fromJson(a))
//                 .toList() ??
//             [],
//       );
// }
// lib/features/products/data/models/product_model.dart

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
  ProductAddonModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory ProductAddonModel.fromJson(Map<String, dynamic> json) {
    return ProductAddonModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
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
    );
  }
  ProductAddonEntity toEntity() {
    return ProductAddonEntity(id: id, name: name, price: price);
  }
}

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
  });

  // 1. استقبال البيانات من Firebase Firestore (JSON)
  factory ProductModel.fromJson(Map<String, dynamic> json, String docId) {
    return ProductModel(
      id: docId,
      name: json['name'] ?? '',
      categoryId: json['category'] ?? '',
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
    );
  }

  // 2. إرسال البيانات إلى Firebase Firestore (JSON)
  Map<String, dynamic> toJson() {
    return {
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
    );
  }
}
