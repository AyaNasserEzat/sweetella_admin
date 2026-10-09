import 'package:flutter/material.dart';
import 'package:sweetella_admin/features/categories/domain/entities/category.dart';

class CategoriesTable extends StatelessWidget {
  const CategoriesTable({
    required this.categories,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final List<Category> categories;
  final ValueChanged<Category> onEdit;
  final ValueChanged<Category> onDelete;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Image')),
            DataColumn(label: Text('Category name')),
            DataColumn(label: Text('Actions')),
          ],
          rows: categories
              .map((category) {
                return DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 52,
                        height: 52,
                        child: category.image.isEmpty
                            ? const Icon(Icons.category)
                            : Image.network(
                                category.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                              ),
                      ),
                    ),
                    DataCell(Text(category.categoryName)),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Edit',
                            onPressed: () => onEdit(category),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            onPressed: () => onDelete(category),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              })
              .toList(growable: false),
        ),
      ),
    );
  }
}
