import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_attributes_editor.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_basic_fields.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_data.dart';

class ProductFormBody extends StatelessWidget {
  const ProductFormBody({
    required this.formKey,
    required this.data,
    required this.categories,
    required this.isEditing,
    required this.isSaving,
    required this.compact,
    required this.attributesError,
    required this.onCategoryChanged,
    required this.onAddAttribute,
    required this.onRemoveAttribute,
    required this.onAddOption,
    required this.onRemoveOption,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final ProductFormData data;
  final List<ProductCategory> categories;
  final bool isEditing;
  final bool isSaving;
  final bool compact;
  final String? attributesError;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onAddAttribute;
  final ValueChanged<int> onRemoveAttribute;
  final ValueChanged<int> onAddOption;
  final void Function(int attributeIndex, int optionIndex) onRemoveOption;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProductBasicFields(
              data: data,
              categories: categories,
              compact: compact,
              wideFieldWidth:
                  (MediaQuery.sizeOf(context).width * 0.75 - tokens.space.md) /
                  2,
              enabled: !isSaving,
              onCategoryChanged: onCategoryChanged,
            ),
            if (categories.isEmpty && !isEditing) ...[
              SizedBox(height: tokens.space.sm),
              Text(
                l10n.noCategories,
                style: tokens.text.bodySmall.copyWith(
                  color: tokens.color.warning,
                ),
              ),
            ],
            SizedBox(height: tokens.space.xl),
            ProductAttributesEditor(
              attributes: data.attributes,
              error: attributesError,
              compact: compact,
              enabled: !isSaving,
              onAddAttribute: onAddAttribute,
              onRemoveAttribute: onRemoveAttribute,
              onAddOption: onAddOption,
              onRemoveOption: onRemoveOption,
            ),
          ],
        ),
      ),
    );
  }
}
