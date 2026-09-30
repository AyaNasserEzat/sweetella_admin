import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';

abstract interface class ProductRepository {
  Future<List<Product>> getProducts();

  Future<List<ProductCategory>> getCategories();

  Future<Product> addProduct(Product product);

  Future<void> updateProduct(Product product);

  Future<void> deleteProduct(String id);
}
