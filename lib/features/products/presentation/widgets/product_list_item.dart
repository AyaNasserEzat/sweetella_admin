import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({
    required this.product,
    required this.categoryName,
    required this.compact,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Product product;
  final String categoryName;
  final bool compact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final amount = product.salePrice > 0 ? product.salePrice : product.price;
    final formattedPrice = NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      name: l10n.currencyCode,
      decimalDigits: 0,
    ).format(amount);

    return Container(
      padding: EdgeInsets.all(tokens.space.md),
      decoration: BoxDecoration(
        color: tokens.color.surface,
        borderRadius: BorderRadius.circular(tokens.radius.md),
        border: Border.all(color: tokens.color.border),
      ),
      child: compact
          ? _buildCompact(context, tokens, formattedPrice)
          : _buildExpanded(context, tokens, formattedPrice),
    );
  }

  Widget _buildCompact(
    BuildContext context,
    AppTokens tokens,
    String formattedPrice,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _ProductImage(product: product, tokens: tokens),
            SizedBox(width: tokens.space.md),
            Expanded(
              child: _ProductName(product: product, tokens: tokens),
            ),
            _ProductActions(onEdit: onEdit, onDelete: onDelete),
          ],
        ),
        SizedBox(height: tokens.space.md),
        Wrap(
          spacing: tokens.space.lg,
          runSpacing: tokens.space.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _Detail(label: context.l10n.category, value: categoryName),
            _Detail(label: context.l10n.price, value: formattedPrice),
            _Availability(product: product, tokens: tokens),
          ],
        ),
      ],
    );
  }

  Widget _buildExpanded(
    BuildContext context,
    AppTokens tokens,
    String formattedPrice,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Row(
            children: [
              _ProductImage(product: product, tokens: tokens),
              SizedBox(width: tokens.space.md),
              Expanded(
                child: _ProductName(product: product, tokens: tokens),
              ),
            ],
          ),
        ),
        Expanded(flex: 2, child: Text(categoryName, style: tokens.text.body)),
        Expanded(
          flex: 2,
          child: Text(formattedPrice, style: tokens.text.amount),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: _Availability(product: product, tokens: tokens),
          ),
        ),
        _ProductActions(onEdit: onEdit, onDelete: onDelete),
      ],
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.product, required this.tokens});

  final Product product;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final size = tokens.size.profileAvatar;
    final cacheDimension = (size * MediaQuery.devicePixelRatioOf(context))
        .round();
    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radius.sm),
      child: SizedBox.square(
        dimension: size,
        child: product.imageUrl.isEmpty
            ? _imagePlaceholder(tokens)
            : Image.network(
                product.imageUrl,
                width: size,
                height: size,
                cacheWidth: cacheDimension,
                cacheHeight: cacheDimension,
                fit: BoxFit.cover,
                semanticLabel: context.l10n.productImage(product.name),
                errorBuilder: (context, error, stackTrace) =>
                    _imagePlaceholder(tokens),
              ),
      ),
    );
  }

  Widget _imagePlaceholder(AppTokens tokens) {
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

class _ProductName extends StatelessWidget {
  const _ProductName({required this.product, required this.tokens});

  final Product product;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Text(product.name, style: tokens.text.titleSmall);
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: tokens.text.bodySmall),
        Text(value, style: tokens.text.body),
      ],
    );
  }
}

class _Availability extends StatelessWidget {
  const _Availability({required this.product, required this.tokens});

  final Product product;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final available = product.isAvailable;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.space.sm,
        vertical: tokens.space.xs,
      ),
      decoration: BoxDecoration(
        color: available ? tokens.color.successSoft : tokens.color.dangerSoft,
        borderRadius: BorderRadius.circular(tokens.radius.pill),
      ),
      child: Text(
        available ? context.l10n.available : context.l10n.outOfStock,
        style: tokens.text.chip.copyWith(
          color: available ? tokens.color.success : tokens.color.danger,
        ),
      ),
    );
  }
}

class _ProductActions extends StatelessWidget {
  const _ProductActions({required this.onEdit, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: l10n.editProduct,
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          tooltip: l10n.deleteProduct,
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }
}
