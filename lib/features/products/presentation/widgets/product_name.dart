import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';

class ProductName extends StatelessWidget {
  const ProductName({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Text(product.name, style: context.tokens.text.titleSmall);
  }
}
