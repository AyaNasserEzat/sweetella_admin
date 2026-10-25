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
    this.price,
    this.stock,
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
      price: 0.0,
      stock: 0,
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
  final double? price;
  final int? stock;

  ProductEntity copyWith({
    String? id,
    String? name,
    String? categoryId,
    String? categoryName,
    String? description,
    String? imageUrl,
    bool? isAvailable,
    bool? hasVariants,
    bool? hasAddons,
    List<ProductVariantEntity>? variants,
    List<ProductAddonEntity>? addons,
    double? price,
    int? stock,
  }) {
    return ProductEntity(
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
    required this.stock,
  });

  final String id;
  final String name;
  final double price;
  final int stock;
}
