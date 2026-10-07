import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.price,
    required this.salePrice,
    required this.imageUrl,
    required this.attributes,
  });

  factory ProductModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    if (data == null) {
      throw FormatException('Product ${document.id} has no data.');
    }

    final rawAttributes = data['attributes'] as List<dynamic>? ?? const [];
    return ProductModel(
      id: document.id,
      name: data['name'] as String? ?? '',
      categoryId: data['categoryId'] as String? ?? '',
      categoryName: data['categoryName'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: (data['price'] as num?)?.toInt() ?? 0,
      salePrice: (data['salePrice'] as num?)?.toInt() ?? 0,
      imageUrl: data['imageUrl'] as String? ?? '',
      attributes: rawAttributes
          .map((attribute) {
            final attributeData = Map<String, dynamic>.from(attribute as Map);
            final rawOptions =
                attributeData['options'] as List<dynamic>? ?? const [];
            return ProductAttribute(
              title: attributeData['title'] as String? ?? '',
              options: rawOptions
                  .map((option) {
                    final optionData = Map<String, dynamic>.from(option as Map);
                    return ProductOption(
                      value: optionData['value'] as String? ?? '',
                      priceModifier:
                          (optionData['price_modifier'] as num?)?.toDouble() ??
                          0,
                      stock: (optionData['stock'] as num?)?.toInt() ?? 0,
                    );
                  })
                  .toList(growable: false),
            );
          })
          .toList(growable: false),
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      categoryId: product.categoryId,
      categoryName: product.categoryName,
      description: product.description,
      price: product.price,
      salePrice: product.salePrice,
      imageUrl: product.imageUrl,
      attributes: product.attributes,
    );
  }

  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String description;
  final int price;
  final int salePrice;
  final String imageUrl;
  final List<ProductAttribute> attributes;

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      price: price,
      salePrice: salePrice,
      imageUrl: imageUrl,
      attributes: attributes,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'salePrice': salePrice,
      'attributes': attributes
          .map(
            (attribute) => {
              'title': attribute.title,
              'options': attribute.options
                  .map(
                    (option) => {
                      'value': option.value,
                      'price_modifier': option.priceModifier,
                      'stock': option.stock,
                    },
                  )
                  .toList(growable: false),
            },
          )
          .toList(growable: false),
    };
  }
}
