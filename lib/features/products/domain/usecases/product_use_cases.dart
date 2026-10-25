import 'package:dartz/dartz.dart';
import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
import 'package:sweetella_admin/features/products/domain/repositories/product_repository.dart';

// class GetProducts {
//   const GetProducts(this._repository);

//   final ProductRepository _repository;

//   Future<Either<Failure, List<ProductEntity>>> call() => _repository.getProducts();
// }

class GetProductCategories {
  const GetProductCategories(this._repository);

  final ProductRepository _repository;

  Future<List<ProductCategory>> call() => _repository.getCategories();
}

class GetProductsUseCase {
  final ProductRepository repository;
  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call() =>
      repository.getProducts();
}

class AddProductUseCase {
  final ProductRepository repository;
  AddProductUseCase(this.repository);

  Future<Either<Failure, ProductEntity>> call(ProductEntity product) =>
      repository.addProduct(product);
}

class UpdateProductUseCase {
  final ProductRepository repository;
  UpdateProductUseCase(this.repository);

  Future<Either<Failure, void>> call(ProductEntity product) =>
      repository.updateProduct(product);
}

class DeleteProductUseCase {
  final ProductRepository repository;
  DeleteProductUseCase(this.repository);

  Future<Either<Failure, void>> call(String productId) =>
      repository.deleteProduct(productId);
}
