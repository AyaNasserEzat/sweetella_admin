import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/di/service_locator.dart';
import 'package:sweetella_admin/core/error/app_failuer)localization.dart';
import 'package:sweetella_admin/core/widgets/custom_overlay_message.dart';
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
    final tokens = context.tokens;
    final colors = tokens.color;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(tokens.space.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Categories',
                    style: tokens.text.title.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => _openForm(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add category'),
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.brand,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: tokens.space.lg,
                      vertical: tokens.space.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(tokens.radius.md),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: tokens.space.xl),
            Expanded(
              child: BlocConsumer<CategoryCubit, CategoryState>(
                listener: (context, state) {
                  if (state is CategoryDeleteError) {
                    showOverlayMessage(
                      context: context,
                      text: state.failure.message(context),
                      isError: true,
                    );
                  } else if (state is CategoryUpdateError) {
                    showOverlayMessage(
                      context: context,
                      text: state.failure.message(context),
                      isError: true,
                    );
                  } else if (state is CategoryDeleteSuccess) {
                    showOverlayMessage(
                      context: context,
                      text: 'Category deleted successfully',
                    );
                  } else if (state is CategoryAddSuccess) {
                    Navigator.of(context).pop();
                    showOverlayMessage(
                      context: context,
                      text: 'Category added successfully',
                    );
                  } else if (state is CategoryUpdateSuccess) {
                    Navigator.of(context).pop();
                    showOverlayMessage(
                      context: context,
                      text: 'Category updated successfully',
                    );
                  }
                },
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: colors.brand),
                    );
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
                    return Center(
                      child: Text(
                        'Failed to load categories',
                        style: tokens.text.body.copyWith(color: colors.danger),
                      ),
                    );
                  }

                  if (categories.isEmpty) {
                    return Center(
                      child: Text(
                        'No categories found',
                        style: tokens.text.body.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    );
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
    final tokens = context.tokens;
    final colors = tokens.color;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radius.lg),
        ),
        title: Text(
          'Delete category',
          style: tokens.text.titleSmall.copyWith(color: colors.textPrimary),
        ),
        content: Text(
          'Delete "${category.categoryName}"?',
          style: tokens.text.body.copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            style: TextButton.styleFrom(foregroundColor: colors.textSecondary),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: colors.danger,
              foregroundColor: Colors.white,
            ),
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
