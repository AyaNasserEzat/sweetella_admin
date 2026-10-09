import 'package:dartz/dartz.dart';
import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/features/categories/domain/entities/category.dart';
import 'package:sweetella_admin/features/categories/domain/repositories/category_repository.dart';

class AddCategory {
  const AddCategory(this._repository);

  final CategoryRepository _repository;

  Future<Either<Failure, Unit>> call(Category category) =>
      _repository.addCategory(category);
}
