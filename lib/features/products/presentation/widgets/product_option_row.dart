import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_option_form_data.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_text_field.dart';

class ProductOptionRow extends StatelessWidget {
  const ProductOptionRow({
    required this.option,
    required this.compact,
    required this.enabled,
    required this.onRemove,
    super.key,
  });

  final ProductOptionFormData option;
  final bool compact;
  final bool enabled;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final fields = [
      ProductFormTextField(
        controller: option.valueController,
        label: l10n.optionValue,
        enabled: enabled,
        required: true,
      ),
      ProductFormTextField(
        controller: option.priceModifierController,
        label: l10n.priceModifier,
        enabled: enabled,
        required: true,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        validator: (value) =>
            double.tryParse(value ?? '') == null ? l10n.invalidPrice : null,
      ),
      ProductFormTextField(
        controller: option.stockController,
        label: l10n.stock,
        enabled: enabled,
        required: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          final stock = int.tryParse(value ?? '');
          return stock == null || stock < 0 ? l10n.invalidStock : null;
        },
      ),
    ];

    return Padding(
      padding: EdgeInsets.only(top: tokens.space.sm),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                fields[0],
                SizedBox(height: tokens.space.sm),
                fields[1],
                SizedBox(height: tokens.space.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: fields[2]),
                    IconButton(
                      tooltip: l10n.removeOption,
                      onPressed: enabled ? onRemove : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: fields[0]),
                SizedBox(width: tokens.space.sm),
                Expanded(child: fields[1]),
                SizedBox(width: tokens.space.sm),
                Expanded(child: fields[2]),
                IconButton(
                  tooltip: l10n.removeOption,
                  onPressed: enabled ? onRemove : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
              ],
            ),
    );
  }
}
