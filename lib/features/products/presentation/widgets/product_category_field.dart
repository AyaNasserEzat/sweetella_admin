import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';

class ProductCategoryField extends StatelessWidget {
  const ProductCategoryField({
    required this.categories,
    required this.value,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  final List<ProductCategory> categories;
  final String? value;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: l10n.category),
      items: categories
          .map(
            (category) => DropdownMenuItem(
              value: category.id,
              child: Text(category.name),
            ),
          )
          .toList(growable: false),
      onChanged: enabled ? onChanged : null,
      validator: (selected) =>
          selected == null ? l10n.requiredField(l10n.category) : null,
    );
  }
}
