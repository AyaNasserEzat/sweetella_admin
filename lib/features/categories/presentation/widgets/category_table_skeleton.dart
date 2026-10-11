import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sweetella_admin/features/categories/domain/entities/category.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/categories_table.dart';

class CategoryTableSkeleton extends StatelessWidget {
  const CategoryTableSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: CategoriesTable(
        categories: List.generate(
          5,
          (index) =>
              Category(id: '$index', categoryName: 'Category name', image: ''),
        ),
        onEdit: (_) {},
        onDelete: (_) {},
      ),
    );
  }
}
