import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/usecases/product_use_cases.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit({
    required GetProducts getProducts,
    required AddProduct addProduct,
    required UpdateProduct updateProduct,
    required DeleteProduct deleteProduct,
  }) : _getProducts = getProducts,
       _addProduct = addProduct,
       _updateProduct = updateProduct,
       _deleteProduct = deleteProduct,
       super(const ProductInitial());

  final GetProducts _getProducts;
  final AddProduct _addProduct;
  final UpdateProduct _updateProduct;
  final DeleteProduct _deleteProduct;

  Future<void> loadProducts() async {
    emit(const ProductLoading());

    final result = await _getProducts();

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(ProductLoadError(failure));
      },
      (products) {
        emit(ProductLoadSuccess(products: products));
      },
    );
  }

  Future<bool> add(Product product) async {
    final result = await _addProduct(product);

    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(ProductAddError(failure: failure, products: _currentProducts));
        return false;
      },
      (savedProduct) {
        final products = [..._currentProducts, savedProduct];
        emit(ProductAddSuccess(products: products));
        return true;
      },
    );
  }

  Future<bool> update(Product product) async {
    final result = await _updateProduct(product);

    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(ProductUpdateError(failure: failure, products: _currentProducts));
        return false;
      },
      (_) {
        final products = (_currentProducts)
            .map((current) => current.id == product.id ? product : current)
            .toList(growable: false);
        emit(ProductUpdateSuccess(products: products));
        return true;
      },
    );
  }

  Future<bool> delete(String id) async {
    final result = await _deleteProduct(id);

    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(ProductDeleteError(failure: failure, products: _currentProducts));
        return false;
      },
      (_) {
        final products = _currentProducts
            .where((product) => product.id != id)
            .toList(growable: false);
        emit(ProductDeleteSuccess(products: products));
        return true;
      },
    );
  }

  List<Product> get _currentProducts => state is ProductDataState
      ? (state as ProductDataState).products
      : const [];
}
