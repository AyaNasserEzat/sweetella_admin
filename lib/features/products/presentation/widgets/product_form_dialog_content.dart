import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_data.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_dialog_actions.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_body.dart';

class ProductFormDialogContent extends StatelessWidget {
  const ProductFormDialogContent({
    required this.formKey,
    required this.data,
    required this.categories,
    required this.isEditing,
    required this.isSaving,
    required this.compact,
    required this.dialogWidth,
    required this.attributesError,
    required this.onCategoryChanged,
    required this.onAddAttribute,
    required this.onRemoveAttribute,
    required this.onAddOption,
    required this.onRemoveOption,
    required this.onSave,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final ProductFormData data;
  final List<ProductCategory> categories;
  final bool isEditing;
  final bool isSaving;
  final bool compact;
  final double dialogWidth;
  final String? attributesError;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onAddAttribute;
  final ValueChanged<int> onRemoveAttribute;
  final ValueChanged<int> onAddOption;
  final void Function(int attributeIndex, int optionIndex) onRemoveOption;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(isEditing ? l10n.editProduct : l10n.addProduct),
      content: SizedBox(
        width: dialogWidth,
        child: ProductFormBody(
          formKey: formKey,
          data: data,
          categories: categories,
          isEditing: isEditing,
          isSaving: isSaving,
          compact: compact,
          attributesError: attributesError,
          onCategoryChanged: onCategoryChanged,
          onAddAttribute: onAddAttribute,
          onRemoveAttribute: onRemoveAttribute,
          onAddOption: onAddOption,
          onRemoveOption: onRemoveOption,
        ),
      ),
      actions: [
        ProductFormDialogActions(
          isEditing: isEditing,
          isSaving: isSaving,
          onCancel: () => Navigator.of(context).pop(false),
          onSave: onSave,
        ),
      ],
    );
  }
}
