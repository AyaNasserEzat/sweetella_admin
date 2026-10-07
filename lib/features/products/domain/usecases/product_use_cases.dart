import 'package:dartz/dartz.dart';
import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
import 'package:sweetella_admin/features/products/domain/repositories/product_repository.dart';

class GetProducts {
  const GetProducts(this._repository);

  final ProductRepository _repository;

  Future<Either<Failure, List<Product>>> call() => _repository.getProducts();
}

class GetProductCategories {
  const GetProductCategories(this._repository);

  final ProductRepository _repository;

  Future<List<ProductCategory>> call() => _repository.getCategories();
}

class AddProduct {
  const AddProduct(this._repository);

  final ProductRepository _repository;

  Future<Either<Failure, Product>> call(Product product) =>
      _repository.addProduct(product);
}

class UpdateProduct {
  const UpdateProduct(this._repository);

  final ProductRepository _repository;

  Future<Either<Failure, void>> call(Product product) =>
      _repository.updateProduct(product);
}

class DeleteProduct {
  const DeleteProduct(this._repository);

  final ProductRepository _repository;

  Future<Either<Failure, void>> call(String id) =>
      _repository.deleteProduct(id);
}
