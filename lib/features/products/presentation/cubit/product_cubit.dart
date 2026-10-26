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
  List<ProductEntity> _products = [];
  Future<void> fetchProducts() async {
    emit(ProductLoading());
    final result = await getProductsUseCase();
    result.fold((failure) => emit(ProductError(failure)), (products) {
      // 👇 هنا الحل: نحولها لـ List قابلة للتعديل والإضافة والحذف
      _products = List.from(products);

      emit(ProductLoaded(products: List.from(_products)));
    });
  }

  Future<void> addProduct(ProductEntity product) async {
    emit(ProductLoading());
    final result = await addProductUseCase(product);
    if (isClosed) return;
    result.fold((failure) => emit(ProductError(failure)), (newProduct) {
      // 1. إضافة المنتج الجديد اللي راجع من السيرفر (بالـ ID الحقيقي) للقائمة المحلية
      _products.add(newProduct);

      emit(
        ProductLoaded(
          products: List.from(_products),
          successMessage: 'Product added successfully',
        ),
      );
    });
  }

  Future<void> updateProduct(ProductEntity product) async {
    emit(ProductLoading());
    final result = await updateProductUseCase(product);
    result.fold((failure) => emit(ProductError(failure)), (_) {
      // 1. إيجاد العنصر وتحديثه في القائمة المحلية بناءً على الـ ID
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
      }

      emit(
        ProductLoaded(
          products: List.from(_products),
          successMessage: 'Product updated successfully',
        ),
      );
    });
  }

  Future<void> deleteProduct(String productId) async {
    //  emit(DeleteProductLoading());
    final result = await deleteProductUseCase(productId);
    if (isClosed) return;

    result.fold((failure) => emit(ProductError(failure)), (_) {
      // 1. حذف العنصر من القائمة المحلية فوراً
      _products.removeWhere((product) => product.id == productId);

      emit(
        ProductLoaded(
          products: List.from(_products),
          successMessage: 'Product deleted successfully',
        ),
      );
    });
  }
}
