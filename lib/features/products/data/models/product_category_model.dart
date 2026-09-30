import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';

class ProductCategoryModel {
  const ProductCategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory ProductCategoryModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    if (data == null) {
      throw FormatException('Category ${document.id} has no data.');
    }

    return ProductCategoryModel(
      id: document.id,
      name: data['category_name'] as String? ?? '',
      imageUrl: data['image'] as String? ?? '',
    );
  }

  final String id;
  final String name;
  final String imageUrl;

  ProductCategory toEntity() {
    return ProductCategory(id: id, name: name, imageUrl: imageUrl);
  }
}
