import 'package:sweetella_admin/features/products/data/datasources/product_remote_data_source.dart';
import 'package:sweetella_admin/features/products/data/models/product_model.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
import 'package:sweetella_admin/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._remoteDataSource);

  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<List<Product>> getProducts() async {
    final models = await _remoteDataSource.getProducts();
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<List<ProductCategory>> getCategories() async {
    final models = await _remoteDataSource.getCategories();
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<Product> addProduct(Product product) async {
    final model = await _remoteDataSource.addProduct(
      ProductModel.fromEntity(product),
    );
    return model.toEntity();
  }

  @override
  Future<void> updateProduct(Product product) {
    return _remoteDataSource.updateProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> deleteProduct(String id) {
    return _remoteDataSource.deleteProduct(id);
  }
}
