import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/features/categories/domain/entities/category.dart';

sealed class CategoryState {
  const CategoryState();
}

final class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

final class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

sealed class CategoryDataState extends CategoryState {
  const CategoryDataState({required this.categories});

  final List<Category> categories;
}

final class CategoryLoadSuccess extends CategoryDataState {
  const CategoryLoadSuccess({required super.categories});
}

final class CategoryEmpty extends CategoryDataState {
  const CategoryEmpty() : super(categories: const []);
}

final class CategoryLoadError extends CategoryState {
  const CategoryLoadError(this.failure);

  final Failure failure;
}

final class CategoryAddSuccess extends CategoryDataState {
  const CategoryAddSuccess({required super.categories});
}

final class CategoryAddError extends CategoryDataState {
  const CategoryAddError({required this.failure, required super.categories});

  final Failure failure;
}

final class CategoryUpdateSuccess extends CategoryDataState {
  const CategoryUpdateSuccess({required super.categories});
}

final class CategoryUpdateError extends CategoryDataState {
  const CategoryUpdateError({required this.failure, required super.categories});

  final Failure failure;
}

final class CategoryDeleteSuccess extends CategoryDataState {
  const CategoryDeleteSuccess({required super.categories});
}

final class CategoryDeleteError extends CategoryDataState {
  const CategoryDeleteError({required this.failure, required super.categories});

  final Failure failure;
}
