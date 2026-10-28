import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/custom_text_field.dart';

class ProductPriceStockFields extends StatelessWidget {
  const ProductPriceStockFields({
    required this.priceController,
    required this.stockController,
    required this.compact,
    super.key,
  });

  final TextEditingController priceController;
  final TextEditingController stockController;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final stock = CustomTextField(
      controller: stockController,
      keyboardType: TextInputType.number,
      label: 'stock',
      hintText: 'stock',
    );
    final price = CustomTextField(
      controller: priceController,
      keyboardType: TextInputType.number,
      label: 'price',
      hintText: 'price',
    );

    if (compact) {
      return CustomShadowContanier(
        child: Column(
          children: [
            price,
            SizedBox(height: tokens.space.md),
            stock,
          ],
        ),
      );
    }

    return CustomShadowContanier(
      child: Row(
        children: [
          Expanded(child: price),
          SizedBox(width: tokens.space.md),
          Expanded(child: stock),
        ],
      ),
    );
  }
}
