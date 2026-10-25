// class ProductEntity {
//   const ProductEntity({
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

//   factory ProductEntity.empty() {
//     return const ProductEntity(
//       id: '',
//       name: '.........',
//       categoryId: '',
//       categoryName: '.........',
//       description: '',
//       price: 100000,
//       salePrice: 100000,
//       imageUrl: '',
//       attributes: [],
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

//   bool get isAvailable =>
//       attributes.isEmpty ||
//       attributes.any(
//         (attribute) => attribute.options.any((option) => option.stock > 0),
//       );

//   ProductEntity copyWith({String? id}) {
//     return ProductEntity(
//       id: id ?? this.id,
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
// }

// class ProductAttribute {
//   const ProductAttribute({required this.title, required this.options});

//   final String title;
//   final List<ProductOption> options;
// }

// class ProductOption {
//   const ProductOption({
//     required this.value,
//     required this.priceModifier,
//     required this.stock,
//   });

//   final String value;
//   final double priceModifier;
//   final int stock;
// }
class ProductEntity {
  const ProductEntity({
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

  factory ProductEntity.empty() {
    return const ProductEntity(
      id: '',
      name: '.........',
      categoryId: '',
      categoryName: '.........',
      description: '',
      imageUrl: '',
      isAvailable: true,
      hasVariants: false,
      hasAddons: false,
      variants: [],
      addons: [],
    );
  }

  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String description;
  final String imageUrl;
  final bool isAvailable;
  final bool hasVariants;
  final bool hasAddons;
  final List<ProductVariantEntity> variants;
  final List<ProductAddonEntity> addons;

  ProductEntity copyWith({String? id}) {
    return ProductEntity(
      id: id ?? this.id,
      name: name,
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      imageUrl: imageUrl,
      isAvailable: isAvailable,
      hasVariants: hasVariants,
      hasAddons: hasAddons,
      variants: variants,
      addons: addons,
    );
  }
}

class ProductVariantEntity {
  const ProductVariantEntity({
    required this.id,
    required this.sizeName,
    required this.price,
    required this.stock,
  });

  final String id;
  final String sizeName; // مثل: قطعة واحدة / صغير / 1 كيلو
  final double price;
  final int stock;
}

class ProductAddonEntity {
  const ProductAddonEntity({
    required this.id,
    required this.name,
    required this.price,
  });

  final String id;
  final String name;
  final double price;
}
