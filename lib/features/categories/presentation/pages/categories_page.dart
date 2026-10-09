import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/di/service_locator.dart';
import 'package:sweetella_admin/core/utils/app_colors.dart';
import 'package:sweetella_admin/features/categories/domain/entities/category.dart';
import 'package:sweetella_admin/features/categories/presentation/cubit/category_cubit.dart';
import 'package:sweetella_admin/features/categories/presentation/cubit/category_state.dart';
import 'package:sweetella_admin/features/categories/presentation/pages/add_category_screen.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/categories_table.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoryCubit>()..loadCategories(),
      child: const _CategoriesView(),
    );
  }
}

class _CategoriesView extends StatelessWidget {
  const _CategoriesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Categories',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => _openForm(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add category'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final categories = switch (state) {
                    CategoryLoadSuccess(:final categories) => categories,
                    CategoryAddSuccess(:final categories) => categories,
                    CategoryUpdateSuccess(:final categories) => categories,
                    CategoryDeleteSuccess(:final categories) => categories,
                    CategoryAddError(:final categories) => categories,
                    CategoryUpdateError(:final categories) => categories,
                    CategoryDeleteError(:final categories) => categories,
                    CategoryEmpty() => const <Category>[],
                    CategoryLoadError() => const <Category>[],
                    _ => const <Category>[],
                  };

                  if (state is CategoryLoadError && categories.isEmpty) {
                    return const Center(
                      child: Text('Failed to load categories'),
                    );
                  }

                  if (categories.isEmpty) {
                    return const Center(child: Text('No categories found'));
                  }

                  return CategoriesTable(
                    categories: categories,
                    onEdit: (category) =>
                        _openForm(context, category: category),
                    onDelete: (category) => _confirmDelete(context, category),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {Category? category}) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<CategoryCubit>(),
          child: AddCategoryScreen(category: category),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Category category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text('Delete category'),
        content: Text('Delete "${category.categoryName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<CategoryCubit>().deleteCategory(category.id);
    }
  }
}
