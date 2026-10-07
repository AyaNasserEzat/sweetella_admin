import 'package:dartz/dartz.dart';
import 'package:sweetella_admin/core/error/exception_handelr.dart';
import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/features/products/data/datasources/product_remote_data_source.dart';
import 'package:sweetella_admin/features/products/data/models/product_model.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
import 'package:sweetella_admin/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._remoteDataSource);

  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final models = await _remoteDataSource.getProducts();
      List<Product> res = models
          .map((model) => model.toEntity())
          .toList(growable: false);
      return Right(res);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<List<ProductCategory>> getCategories() async {
    final models = await _remoteDataSource.getCategories();
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<Either<Failure, Product>> addProduct(Product product) async {
    try {
      final model = await _remoteDataSource.addProduct(
        ProductModel.fromEntity(product),
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    try {
      await _remoteDataSource.updateProduct(ProductModel.fromEntity(product));
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await _remoteDataSource.deleteProduct(id);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
