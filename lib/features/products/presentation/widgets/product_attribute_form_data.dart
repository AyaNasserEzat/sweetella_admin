import 'package:flutter/material.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_option_form_data.dart';

class ProductAttributeFormData {
  ProductAttributeFormData({String title = ''})
    : titleController = TextEditingController(text: title);

  factory ProductAttributeFormData.fromEntity(ProductAttribute attribute) {
    return ProductAttributeFormData(title: attribute.title)
      ..options.addAll(attribute.options.map(ProductOptionFormData.fromEntity));
  }

  final TextEditingController titleController;
  final List<ProductOptionFormData> options = [];

  ProductAttribute toEntity() {
    return ProductAttribute(
      title: titleController.text.trim(),
      options: options.map((option) => option.toEntity()).toList(),
    );
  }

  void dispose() {
    titleController.dispose();
    for (final option in options) {
      option.dispose();
    }
  }
}
