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
    final colors = tokens.color;

    final borderSide = BorderSide(color: colors.border, width: 1);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataRowMinHeight: tokens.size.listRowHeight + tokens.space.md,
          dataRowMaxHeight: tokens.size.listRowHeight + tokens.space.md,
          headingRowHeight: tokens.size.listRowHeight + tokens.space.xs,
          headingRowColor: WidgetStatePropertyAll(colors.surfaceAlt),
          border: TableBorder(
            horizontalInside: borderSide,
            top: borderSide,
            bottom: borderSide,
            left: borderSide,
            right: borderSide,
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
                    index.isEven ? colors.surface : colors.surfaceAlt,
                  ),
                  cells: [
                    DataCell(
                      SizedBox(
                        width: tokens.size.profileAvatar + tokens.space.sm,
                        height: tokens.size.profileAvatar + tokens.space.sm,
                        child: category.image.isEmpty
                            ? Icon(
                                Icons.category,
                                color: colors.icon,
                                size: tokens.size.icon + tokens.space.xs,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  tokens.radius.sm,
                                ),
                                child: Image.network(
                                  category.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.broken_image,
                                        color: colors.icon,
                                      ),
                                ),
                              ),
                      ),
                    ),
                    DataCell(
                      Text(category.categoryName, style: tokens.text.body),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Edit',
                            onPressed: () => onEdit(category),
                            icon: Icon(
                              Icons.edit_outlined,
                              color: colors.icon,
                              size: tokens.size.icon,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            onPressed: () => onDelete(category),
                            icon: Icon(
                              Icons.delete_outline,
                              color: colors.danger,
                              size: tokens.size.icon,
                            ),
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
