class Product {
  const Product({
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

  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String description;
  final int price;
  final int salePrice;
  final String imageUrl;
  final List<ProductAttribute> attributes;

  bool get isAvailable =>
      attributes.isEmpty ||
      attributes.any(
        (attribute) => attribute.options.any((option) => option.stock > 0),
      );

  Product copyWith({String? id}) {
    return Product(
      id: id ?? this.id,
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
}

class ProductAttribute {
  const ProductAttribute({required this.title, required this.options});

  final String title;
  final List<ProductOption> options;
}

class ProductOption {
  const ProductOption({
    required this.value,
    required this.priceModifier,
    required this.stock,
  });

  final String value;
  final double priceModifier;
  final int stock;
}
