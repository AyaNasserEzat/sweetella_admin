import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetella_admin/core/services/firebase_service.dart';
import 'package:sweetella_admin/features/categories/data/models/category_model.dart';

class CategoryRemoteDataSource {
  CategoryRemoteDataSource(this._firebaseServices);

  final FirebaseServices _firebaseServices;

  CollectionReference<Map<String, dynamic>> get _categories =>
      _firebaseServices.firestore.collection('categories');

  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _categories.orderBy('category_name').get();

    return snapshot.docs
        .map((doc) => CategoryModel.fromMap(doc.id, doc.data()))
        .toList(growable: false);
  }

  Future<void> addCategory(CategoryModel category) async {
    await _categories.add(category.toMap());
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _categories.doc(category.id).update(category.toMap());
  }

  Future<void> deleteCategory(String id) async {
    await _categories.doc(id).delete();
  }
}
