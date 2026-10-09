import 'package:dartz/dartz.dart';
import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/features/categories/domain/entities/category.dart';

abstract interface class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, Unit>> addCategory(Category category);

  Future<Either<Failure, Unit>> updateCategory(Category category);

  Future<Either<Failure, Unit>> deleteCategory(String id);
}
