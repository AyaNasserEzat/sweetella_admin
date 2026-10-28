import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

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
    final stock = TextFormField(
      controller: stockController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Stock',
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
    final price = TextFormField(
      controller: priceController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Price',
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );

    if (compact) {
      return Column(
        children: [
          stock,
          SizedBox(height: tokens.space.md),
          price,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: stock),
        SizedBox(width: tokens.space.md),
        Expanded(child: price),
      ],
    );
  }
}
