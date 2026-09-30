import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
import 'package:sweetella_admin/features/products/domain/errors/product_failure.dart';
import 'package:sweetella_admin/features/products/domain/usecases/product_use_cases.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit({
    required GetProducts getProducts,
    required GetProductCategories getCategories,
    required AddProduct addProduct,
    required UpdateProduct updateProduct,
    required DeleteProduct deleteProduct,
  }) : _getProducts = getProducts,
       _getCategories = getCategories,
       _addProduct = addProduct,
       _updateProduct = updateProduct,
       _deleteProduct = deleteProduct,
       super(const ProductInitial());

  final GetProducts _getProducts;
  final GetProductCategories _getCategories;
  final AddProduct _addProduct;
  final UpdateProduct _updateProduct;
  final DeleteProduct _deleteProduct;

  Future<void> loadProducts() async {
    emit(const ProductLoading());
    try {
      final products = await _getProducts();
      if (isClosed) return;
      final categories = await _getCategories();
      if (isClosed) return;
      if (products.isEmpty) {
        emit(ProductEmpty(categories: categories));
      } else {
        emit(ProductLoadSuccess(products: products, categories: categories));
      }
    } catch (error) {
      if (isClosed) return;
      emit(ProductLoadError(_failureKind(error)));
    }
  }

  Future<bool> add(Product product) async {
    try {
      final savedProduct = await _addProduct(product);
      if (isClosed) return false;
      final data = _currentData;
      final products = [...?data?.products, savedProduct];
      emit(
        ProductAddSuccess(products: products, categories: _categories(data)),
      );
      return true;
    } catch (error) {
      if (isClosed) return false;
      final data = _currentData;
      emit(
        ProductAddError(
          failure: _failureKind(error),
          products: data?.products ?? const [],
          categories: _categories(data),
        ),
      );
      return false;
    }
  }

  Future<bool> update(Product product) async {
    try {
      await _updateProduct(product);
      if (isClosed) return false;
      final data = _currentData;
      final products = (data?.products ?? const <Product>[])
          .map((current) => current.id == product.id ? product : current)
          .toList(growable: false);
      emit(
        ProductUpdateSuccess(products: products, categories: _categories(data)),
      );
      return true;
    } catch (error) {
      if (isClosed) return false;
      final data = _currentData;
      emit(
        ProductUpdateError(
          failure: _failureKind(error),
          products: data?.products ?? const [],
          categories: _categories(data),
        ),
      );
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _deleteProduct(id);
      if (isClosed) return false;
      final data = _currentData;
      final products = (data?.products ?? const <Product>[])
          .where((product) => product.id != id)
          .toList(growable: false);
      emit(
        ProductDeleteSuccess(products: products, categories: _categories(data)),
      );
      return true;
    } catch (error) {
      if (isClosed) return false;
      final data = _currentData;
      emit(
        ProductDeleteError(
          failure: _failureKind(error),
          products: data?.products ?? const [],
          categories: _categories(data),
        ),
      );
      return false;
    }
  }

  ProductDataState? get _currentData =>
      state is ProductDataState ? state as ProductDataState : null;

  List<ProductCategory> _categories(ProductDataState? data) =>
      data?.categories ?? const [];

  ProductFailureKind _failureKind(Object error) {
    return error is ProductFailure ? error.kind : ProductFailureKind.unknown;
  }
}
