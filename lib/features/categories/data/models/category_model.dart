import 'package:sweetella_admin/features/categories/domain/entities/category.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.categoryName,
    required this.image,
  });

  final String id;
  final String categoryName;
  final String image;

  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) {
    return CategoryModel(
      id: id,
      categoryName: map['category_name'] as String? ?? '',
      image: map['image'] as String? ?? '',
    );
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      categoryName: category.categoryName,
      image: category.image,
    );
  }

  Category toEntity() {
    return Category(id: id, categoryName: categoryName, image: image);
  }

  Map<String, dynamic> toMap() {
    return {'category_name': categoryName, 'image': image};
  }
}
