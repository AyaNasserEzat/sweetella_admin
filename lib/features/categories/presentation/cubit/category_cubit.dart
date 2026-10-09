import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/features/categories/domain/entities/category.dart';
import 'package:sweetella_admin/features/categories/domain/usecases/add_category.dart';
import 'package:sweetella_admin/features/categories/domain/usecases/delete_category.dart';
import 'package:sweetella_admin/features/categories/domain/usecases/get_categories.dart';
import 'package:sweetella_admin/features/categories/domain/usecases/update_category.dart';
import 'package:sweetella_admin/features/categories/presentation/cubit/category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({
    required GetCategories getCategories,
    required AddCategory addCategory,
    required UpdateCategory updateCategory,
    required DeleteCategory deleteCategory,
  }) : _getCategories = getCategories,
       _addCategory = addCategory,
       _updateCategory = updateCategory,
       _deleteCategory = deleteCategory,
       super(const CategoryInitial());

  final GetCategories _getCategories;
  final AddCategory _addCategory;
  final UpdateCategory _updateCategory;
  final DeleteCategory _deleteCategory;

  Future<void> loadCategories() async {
    emit(const CategoryLoading());

    final result = await _getCategories();

    if (isClosed) return;

    result.fold((failure) => emit(CategoryLoadError(failure)), (categories) {
      if (categories.isEmpty) {
        emit(const CategoryEmpty());
        return;
      }
      emit(CategoryLoadSuccess(categories: categories));
    });
  }

  Future<bool> addCategory(Category category) async {
    final result = await _addCategory(category);

    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(
          CategoryAddError(failure: failure, categories: _currentCategories),
        );
        return false;
      },
      (_) async {
        final categoriesResult = await _getCategories();

        if (isClosed) return false;

        return categoriesResult.fold(
          (failure) {
            emit(
              CategoryAddError(
                failure: failure,
                categories: _currentCategories,
              ),
            );
            return false;
          },
          (categories) {
            if (categories.isEmpty) {
              emit(const CategoryEmpty());
            } else {
              emit(CategoryAddSuccess(categories: categories));
            }
            return true;
          },
        );
      },
    );
  }

  // Future<bool> addCategory(Category category) async {
  //   final result = await _addCategory(category);

  //   if (isClosed) return false;

  //   return result.fold(
  //     (failure) {
  //       emit(
  //         CategoryAddError(failure: failure, categories: _currentCategories),
  //       );
  //       return false;
  //     },
  //     (_) {
  //       final categories = [..._currentCategories, category];
  //       emit(CategoryAddSuccess(categories: categories));
  //       return true;
  //     },
  //   );
  // }

  Future<bool> updateCategory(Category category) async {
    final result = await _updateCategory(category);

    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(
          CategoryUpdateError(failure: failure, categories: _currentCategories),
        );
        return false;
      },
      (_) async {
        final categories = _currentCategories
            .map((current) => current.id == category.id ? category : current)
            .toList(growable: false);

        emit(CategoryUpdateSuccess(categories: categories));
        return true;
      },
    );
  }

  Future<bool> deleteCategory(String id) async {
    final result = await _deleteCategory(id);

    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(
          CategoryDeleteError(failure: failure, categories: _currentCategories),
        );
        return false;
      },
      (_) {
        final categories = _currentCategories
            .where((category) => category.id != id)
            .toList(growable: false);
        emit(CategoryDeleteSuccess(categories: categories));
        return true;
      },
    );
  }

  List<Category> get _currentCategories => state is CategoryDataState
      ? (state as CategoryDataState).categories
      : const [];
}
