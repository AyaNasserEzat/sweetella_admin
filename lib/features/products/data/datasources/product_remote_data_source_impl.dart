import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetella_admin/core/services/firebase_service.dart';
import 'package:sweetella_admin/features/products/data/datasources/product_remote_data_source.dart';
import 'package:sweetella_admin/features/products/data/models/product_category_model.dart';
import 'package:sweetella_admin/features/products/data/models/product_model.dart';
import 'package:sweetella_admin/features/products/domain/errors/product_failure.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl(this._firebaseServices);

  static const productsCollection = 'Products';
  static const categoriesCollection = 'categories';

  final FirebaseServices _firebaseServices;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firebaseServices.firestore.collection(productsCollection);

  @override
  Future<List<ProductModel>> getProducts() {
    return _guard(() async {
      final snapshot = await _products.get();
      return snapshot.docs.map(ProductModel.fromSnapshot).toList();
    });
  }

  @override
  Future<List<ProductCategoryModel>> getCategories() {
    return _guard(() async {
      final snapshot = await _firebaseServices.firestore
          .collection(categoriesCollection)
          .get();
      return snapshot.docs.map(ProductCategoryModel.fromSnapshot).toList();
    });
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) {
    return _guard(() async {
      final document = _products.doc();
      final savedProduct = ProductModel(
        id: document.id,
        name: product.name,
        categoryId: product.categoryId,
        description: product.description,
        price: product.price,
        salePrice: product.salePrice,
        imageUrl: product.imageUrl,
        attributes: product.attributes,
      );
      await document.set(savedProduct.toFirestore());
      return savedProduct;
    });
  }

  @override
  Future<void> updateProduct(ProductModel product) {
    return _guard(() async {
      await _products.doc(product.id).update(product.toFirestore());
    });
  }

  @override
  Future<void> deleteProduct(String id) {
    return _guard(() async {
      await _products.doc(id).delete();
    });
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on ProductFailure {
      rethrow;
    } on FirebaseException catch (error) {
      throw ProductFailure(_failureForCode(error.code));
    } on FormatException {
      throw const ProductFailure(ProductFailureKind.invalidData);
    } on TypeError {
      throw const ProductFailure(ProductFailureKind.invalidData);
    } catch (_) {
      throw const ProductFailure(ProductFailureKind.unknown);
    }
  }

  ProductFailureKind _failureForCode(String code) {
    return switch (code) {
      'permission-denied' ||
      'unauthenticated' => ProductFailureKind.permissionDenied,
      'unavailable' ||
      'deadline-exceeded' ||
      'network-request-failed' => ProductFailureKind.unavailable,
      _ => ProductFailureKind.unknown,
    };
  }
}
