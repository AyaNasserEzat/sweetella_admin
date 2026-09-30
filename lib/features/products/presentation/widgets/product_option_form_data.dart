import 'package:flutter/material.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';

class ProductOptionFormData {
  ProductOptionFormData({
    String value = '',
    String priceModifier = '0',
    String stock = '0',
  }) : valueController = TextEditingController(text: value),
       priceModifierController = TextEditingController(text: priceModifier),
       stockController = TextEditingController(text: stock);

  factory ProductOptionFormData.fromEntity(ProductOption option) {
    return ProductOptionFormData(
      value: option.value,
      priceModifier: option.priceModifier.toString(),
      stock: option.stock.toString(),
    );
  }

  final TextEditingController valueController;
  final TextEditingController priceModifierController;
  final TextEditingController stockController;

  ProductOption toEntity() {
    return ProductOption(
      value: valueController.text.trim(),
      priceModifier: double.parse(priceModifierController.text),
      stock: int.parse(stockController.text),
    );
  }

  void dispose() {
    valueController.dispose();
    priceModifierController.dispose();
    stockController.dispose();
  }
}
