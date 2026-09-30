import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
import 'package:sweetella_admin/features/products/domain/errors/product_failure.dart';

sealed class ProductState {
  const ProductState();
}

final class ProductInitial extends ProductState {
  const ProductInitial();
}

final class ProductLoading extends ProductState {
  const ProductLoading();
}

sealed class ProductDataState extends ProductState {
  const ProductDataState({required this.products, required this.categories});

  final List<Product> products;
  final List<ProductCategory> categories;
}

final class ProductLoadSuccess extends ProductDataState {
  const ProductLoadSuccess({
    required super.products,
    required super.categories,
  });
}

final class ProductEmpty extends ProductDataState {
  const ProductEmpty({required super.categories}) : super(products: const []);
}

final class ProductLoadError extends ProductState {
  const ProductLoadError(this.failure);

  final ProductFailureKind failure;
}

final class ProductAddSuccess extends ProductDataState {
  const ProductAddSuccess({required super.products, required super.categories});
}

final class ProductAddError extends ProductDataState {
  const ProductAddError({
    required this.failure,
    required super.products,
    required super.categories,
  });

  final ProductFailureKind failure;
}

final class ProductUpdateSuccess extends ProductDataState {
  const ProductUpdateSuccess({
    required super.products,
    required super.categories,
  });
}

final class ProductUpdateError extends ProductDataState {
  const ProductUpdateError({
    required this.failure,
    required super.products,
    required super.categories,
  });

  final ProductFailureKind failure;
}

final class ProductDeleteSuccess extends ProductDataState {
  const ProductDeleteSuccess({
    required super.products,
    required super.categories,
  });
}

final class ProductDeleteError extends ProductDataState {
  const ProductDeleteError({
    required this.failure,
    required super.products,
    required super.categories,
  });

  final ProductFailureKind failure;
}
