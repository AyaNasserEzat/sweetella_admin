import 'package:dartz/dartz.dart';
import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';

abstract interface class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();

  Future<List<ProductCategory>> getCategories();

  Future<Either<Failure, ProductEntity>> addProduct(ProductEntity product);

  Future<Either<Failure, void>> updateProduct(ProductEntity product);

  Future<Either<Failure, void>> deleteProduct(String id);
}
