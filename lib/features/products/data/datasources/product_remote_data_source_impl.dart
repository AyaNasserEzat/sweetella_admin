import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetella_admin/core/services/firebase_service.dart';
import 'package:sweetella_admin/features/products/data/datasources/product_remote_data_source.dart';
import 'package:sweetella_admin/features/products/data/models/product_category_model.dart';
import 'package:sweetella_admin/features/products/data/models/product_model.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl(this._firebaseServices);

  static const productsCollection = 'Products';
  static const categoriesCollection = 'categories';

  final FirebaseServices _firebaseServices;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firebaseServices.firestore.collection(productsCollection);

  @override
  Future<List<ProductModel>> getProducts() async {
    final snapshot = await _products.get();
    return snapshot.docs.map(ProductModel.fromSnapshot).toList();
  }

  @override
  Future<List<ProductCategoryModel>> getCategories() async {
    final snapshot = await _firebaseServices.firestore
        .collection(categoriesCollection)
        .get();
    return snapshot.docs.map(ProductCategoryModel.fromSnapshot).toList();
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    final document = _products.doc();
    final savedProduct = ProductModel(
      id: document.id,
      name: product.name,
      categoryId: product.categoryId,
      categoryName: product.categoryName,
      description: product.description,
      price: product.price,
      salePrice: product.salePrice,
      imageUrl: product.imageUrl,
      attributes: product.attributes,
    );
    await document.set(savedProduct.toFirestore());
    return savedProduct;
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await _products.doc(product.id).update(product.toFirestore());
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _products.doc(id).delete();
  }
}
