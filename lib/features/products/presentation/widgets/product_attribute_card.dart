import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_attribute_form_data.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_text_field.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_option_row.dart';

class ProductAttributeCard extends StatelessWidget {
  const ProductAttributeCard({
    required this.attribute,
    required this.attributeIndex,
    required this.compact,
    required this.enabled,
    required this.onRemove,
    required this.onAddOption,
    required this.onRemoveOption,
    super.key,
  });

  final ProductAttributeFormData attribute;
  final int attributeIndex;
  final bool compact;
  final bool enabled;
  final VoidCallback onRemove;
  final VoidCallback onAddOption;
  final ValueChanged<int> onRemoveOption;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return Container(
      margin: EdgeInsets.only(bottom: tokens.space.md),
      padding: EdgeInsets.all(tokens.space.md),
      decoration: BoxDecoration(
        color: tokens.color.surfaceAlt,
        borderRadius: BorderRadius.circular(tokens.radius.md),
        border: Border.all(color: tokens.color.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ProductFormTextField(
                  controller: attribute.titleController,
                  label: l10n.attributeTitle,
                  enabled: enabled,
                  required: true,
                ),
              ),
              IconButton(
                tooltip: l10n.removeAttribute,
                onPressed: enabled ? onRemove : null,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          for (var index = 0; index < attribute.options.length; index++)
            ProductOptionRow(
              key: ValueKey('product-option-$attributeIndex-$index'),
              option: attribute.options[index],
              compact: compact,
              enabled: enabled,
              onRemove: () => onRemoveOption(index),
            ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: enabled ? onAddOption : null,
              icon: const Icon(Icons.add),
              label: Text(l10n.addOption),
            ),
          ),
        ],
      ),
    );
  }
}
