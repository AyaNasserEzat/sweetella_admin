import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class ProductImagePlaceholder extends StatelessWidget {
  const ProductImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return ColoredBox(
      color: tokens.color.surfaceAlt,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: tokens.color.icon,
          size: tokens.size.icon,
        ),
      ),
    );
  }
}
