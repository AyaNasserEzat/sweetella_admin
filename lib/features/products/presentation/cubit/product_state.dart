import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';

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
  const ProductDataState({required this.products});

  final List<Product> products;
}

final class ProductLoadSuccess extends ProductDataState {
  const ProductLoadSuccess({required super.products});
}

final class ProductEmpty extends ProductDataState {
  const ProductEmpty() : super(products: const []);
}

final class ProductLoadError extends ProductState {
  const ProductLoadError(this.failure);

  final Failure failure;
}

final class ProductAddSuccess extends ProductDataState {
  const ProductAddSuccess({required super.products});
}

final class ProductAddError extends ProductDataState {
  const ProductAddError({required this.failure, required super.products});

  final Failure failure;
}

final class ProductUpdateSuccess extends ProductDataState {
  const ProductUpdateSuccess({required super.products});
}

final class ProductUpdateError extends ProductDataState {
  const ProductUpdateError({required this.failure, required super.products});

  final Failure failure;
}

final class ProductDeleteSuccess extends ProductDataState {
  const ProductDeleteSuccess({required super.products});
}

final class ProductDeleteError extends ProductDataState {
  const ProductDeleteError({required this.failure, required super.products});

  final Failure failure;
}
