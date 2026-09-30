import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_image_placeholder.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final size = tokens.size.profileAvatar;
    final cacheDimension = (size * MediaQuery.devicePixelRatioOf(context))
        .round();
    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radius.sm),
      child: SizedBox.square(
        dimension: size,
        child: product.imageUrl.isEmpty
            ? const ProductImagePlaceholder()
            : Image.network(
                product.imageUrl,
                width: size,
                height: size,
                cacheWidth: cacheDimension,
                cacheHeight: cacheDimension,
                fit: BoxFit.cover,
                semanticLabel: context.l10n.productImage(product.name),
                errorBuilder: (context, error, stackTrace) =>
                    const ProductImagePlaceholder(),
              ),
      ),
    );
  }
}
