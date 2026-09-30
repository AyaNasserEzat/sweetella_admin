import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_data.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_text_field.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_validators.dart';

class ProductPriceFields extends StatelessWidget {
  const ProductPriceFields({
    required this.data,
    required this.enabled,
    required this.compact,
    super.key,
  });

  final ProductFormData data;
  final bool enabled;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final price = ProductFormTextField(
      controller: data.priceController,
      label: l10n.price,
      enabled: enabled,
      required: true,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      validator: (value) =>
          ProductFormValidators.price(value, l10n, required: true),
    );
    final salePrice = ProductFormTextField(
      controller: data.salePriceController,
      label: l10n.salePrice,
      enabled: enabled,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      validator: (value) =>
          ProductFormValidators.price(value, l10n, required: false),
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          price,
          SizedBox(height: tokens.space.md),
          salePrice,
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: price),
        SizedBox(width: tokens.space.md),
        Expanded(child: salePrice),
      ],
    );
  }
}
