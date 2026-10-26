import 'package:equatable/equatable.dart';
import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  final String? successMessage;

  ProductLoaded({required this.products, this.successMessage});
  @override
  List<Object?> get props => [products];
}

class ProductError extends ProductState {
  final Failure failure;
  ProductError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class ProductOperationSuccess extends ProductState {
  final String message;
  ProductOperationSuccess(this.message);
}

class AddProductLoading extends ProductState {}

class DeleteProductLoading extends ProductState {}

class UpdateProductLoading extends ProductState {}
