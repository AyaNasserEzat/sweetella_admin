import 'package:sweetella_admin/features/products/data/models/product_category_model.dart';
import 'package:sweetella_admin/features/products/data/models/product_model.dart';

abstract interface class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();

  Future<List<ProductCategoryModel>> getCategories();

  Future<ProductModel> addProduct(ProductModel product);

  Future<void> updateProduct(ProductModel product);

  Future<void> deleteProduct(String id);
}
