import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
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
    final tokens = context.tokens;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataRowMinHeight: 68,
          dataRowMaxHeight: 68,
          headingRowHeight: 56,

          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.grey.shade300, width: 1),
            top: BorderSide(color: Colors.grey.shade300),
            bottom: BorderSide(color: Colors.grey.shade300),
            left: BorderSide(color: Colors.grey.shade300),
            right: BorderSide(color: Colors.grey.shade300),
          ),
          columns: [
            DataColumn(label: Text('Image', style: tokens.text.titleSmall)),
            DataColumn(
              label: Text('Category name', style: tokens.text.titleSmall),
            ),
            DataColumn(label: Text('Actions', style: tokens.text.titleSmall)),
          ],
          rows: categories
              .asMap()
              .entries
              .map((entry) {
                final index = entry.key;
                final category = entry.value;

                return DataRow(
                  color: WidgetStatePropertyAll(
                    index.isEven ? Colors.white : Colors.grey.shade100,
                  ),
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
