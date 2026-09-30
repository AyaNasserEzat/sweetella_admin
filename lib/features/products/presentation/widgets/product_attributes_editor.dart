import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_attribute_card.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_attribute_form_data.dart';

class ProductAttributesEditor extends StatelessWidget {
  const ProductAttributesEditor({
    required this.attributes,
    required this.error,
    required this.compact,
    required this.enabled,
    required this.onAddAttribute,
    required this.onRemoveAttribute,
    required this.onAddOption,
    required this.onRemoveOption,
    super.key,
  });

  final List<ProductAttributeFormData> attributes;
  final String? error;
  final bool compact;
  final bool enabled;
  final VoidCallback onAddAttribute;
  final ValueChanged<int> onRemoveAttribute;
  final ValueChanged<int> onAddOption;
  final void Function(int attributeIndex, int optionIndex) onRemoveOption;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.attributes, style: tokens.text.titleSmall),
            ),
            TextButton.icon(
              onPressed: enabled ? onAddAttribute : null,
              icon: const Icon(Icons.add),
              label: Text(l10n.addAttribute),
            ),
          ],
        ),
        if (error != null) ...[
          SizedBox(height: tokens.space.xs),
          Text(
            error!,
            style: tokens.text.bodySmall.copyWith(color: tokens.color.danger),
          ),
        ],
        SizedBox(height: tokens.space.sm),
        for (var index = 0; index < attributes.length; index++)
          ProductAttributeCard(
            key: ValueKey('product-attribute-$index'),
            attribute: attributes[index],
            attributeIndex: index,
            compact: compact,
            enabled: enabled,
            onRemove: () => onRemoveAttribute(index),
            onAddOption: () => onAddOption(index),
            onRemoveOption: (optionIndex) => onRemoveOption(index, optionIndex),
          ),
      ],
    );
  }
}
