import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_category_field.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_data.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_text_field.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_validators.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_price_fields.dart';

class ProductBasicFields extends StatelessWidget {
  const ProductBasicFields({
    required this.data,
    required this.categories,
    required this.compact,
    required this.wideFieldWidth,
    required this.enabled,
    required this.onCategoryChanged,
    super.key,
  });

  final ProductFormData data;
  final List<ProductCategory> categories;
  final bool compact;
  final double wideFieldWidth;
  final bool enabled;
  final ValueChanged<String?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final nameField = ProductFormTextField(
      controller: data.nameController,
      label: l10n.productName,
      enabled: enabled,
      required: true,
    );
    final categoryField = ProductCategoryField(
      categories: categories,
      value: data.categoryId,
      enabled: enabled,
      onChanged: onCategoryChanged,
    );
    final priceFields = ProductPriceFields(
      data: data,
      enabled: enabled,
      compact: compact,
    );
    final imageField = ProductFormTextField(
      controller: data.imageUrlController,
      label: l10n.imageUrl,
      enabled: enabled,
      required: true,
      keyboardType: TextInputType.url,
      validator: (value) => ProductFormValidators.imageUrl(value, l10n),
    );
    final descriptionField = ProductFormTextField(
      controller: data.descriptionController,
      label: l10n.productDescription,
      enabled: enabled,
      required: true,
      minLines: 2,
      maxLines: 4,
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          nameField,
          SizedBox(height: tokens.space.md),
          categoryField,
          SizedBox(height: tokens.space.md),
          priceFields,
          SizedBox(height: tokens.space.md),
          imageField,
          SizedBox(height: tokens.space.md),
          descriptionField,
        ],
      );
    }

    return Wrap(
      spacing: tokens.space.md,
      runSpacing: tokens.space.md,
      children: [
        SizedBox(width: wideFieldWidth, child: nameField),
        SizedBox(width: wideFieldWidth, child: categoryField),
        SizedBox(
          width: wideFieldWidth * 2 + tokens.space.md,
          child: priceFields,
        ),
        SizedBox(width: wideFieldWidth, child: imageField),
        SizedBox(width: wideFieldWidth, child: descriptionField),
      ],
    );
  }
}
