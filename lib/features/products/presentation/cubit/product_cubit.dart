import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/usecases/product_use_cases.dart';

import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  ProductCubit({
    required this.getProductsUseCase,
    required this.addProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  }) : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    final result = await getProductsUseCase();
    result.fold(
      (failure) => emit(ProductError(failure)),
      (products) => emit(ProductLoaded(products: products)),
    );
  }

  Future<void> addProduct(ProductEntity product) async {
    emit(ProductLoading());
    final result = await addProductUseCase(product);
    if (isClosed) return;
    result.fold(
      (failure) => emit(ProductError(failure)),
      (_) => emit(
        ProductOperationSuccess('Product added successfully'),
      ), // إعادة تحميل القائمة بعد الإضافة
    );
  }

  Future<void> updateProduct(ProductEntity product) async {
    emit(ProductLoading());
    final result = await updateProductUseCase(product);
    result.fold(
      (failure) => emit(ProductError(failure)),
      (_) => emit(
        ProductOperationSuccess('Product updated successfully'),
      ), // إعادة تحميل القائمة بعد التعديل
    );
  }

  Future<void> deleteProduct(String productId) async {
    emit(ProductLoading());
    final result = await deleteProductUseCase(productId);
    result.fold(
      (failure) => emit(ProductError(failure)),
      (_) {
        emit(ProductOperationSuccess('Product deleted successfully'));

        fetchProducts();
      }, // إعادة تحميل القائمة بعد الحذف
    );
  }
}
