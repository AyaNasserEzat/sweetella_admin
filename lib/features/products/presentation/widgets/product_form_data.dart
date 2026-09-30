import 'package:flutter/material.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_attribute_form_data.dart';

class ProductFormData {
  ProductFormData(Product? product)
    : nameController = TextEditingController(text: product?.name ?? ''),
      descriptionController = TextEditingController(
        text: product?.description ?? '',
      ),
      priceController = TextEditingController(
        text: product == null ? '' : product.price.toString(),
      ),
      salePriceController = TextEditingController(
        text: product == null || product.salePrice == 0
            ? ''
            : product.salePrice.toString(),
      ),
      imageUrlController = TextEditingController(text: product?.imageUrl ?? ''),
      categoryId = product?.categoryId,
      attributes =
          product?.attributes
              .map(ProductAttributeFormData.fromEntity)
              .toList() ??
          [];

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController salePriceController;
  final TextEditingController imageUrlController;
  String? categoryId;
  final List<ProductAttributeFormData> attributes;

  Product toProduct(String id) {
    return Product(
      id: id,
      name: nameController.text.trim(),
      categoryId: categoryId!,
      description: descriptionController.text.trim(),
      price: int.parse(priceController.text),
      salePrice: int.tryParse(salePriceController.text) ?? 0,
      imageUrl: imageUrlController.text.trim(),
      attributes: attributes.map((attribute) => attribute.toEntity()).toList(),
    );
  }

  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    salePriceController.dispose();
    imageUrlController.dispose();
    for (final attribute in attributes) {
      attribute.dispose();
    }
  }
}
