import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/errors/product_failure.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_state.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_empty_state.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_load_error_view.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/products_list.dart';

class ProductStateView extends StatelessWidget {
  const ProductStateView({
    required this.state,
    required this.onRetry,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final ProductState state;
  final VoidCallback onRetry;
  final ValueChanged<Product> onEdit;
  final ValueChanged<Product> onDelete;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ProductInitial() ||
      ProductLoading() => const Center(child: CircularProgressIndicator()),
      ProductLoadError(:final failure) => ProductLoadErrorView(
        message: _failureMessage(
          context,
          failure,
          context.l10n.productsLoadError,
        ),
        onRetry: onRetry,
      ),
      ProductDataState(:final products, :final categories) =>
        products.isEmpty
            ? const ProductEmptyState()
            : ProductsList(
                products: products,
                categories: categories,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
    };
  }

  String _failureMessage(
    BuildContext context,
    ProductFailureKind failure,
    String fallback,
  ) {
    return switch (failure) {
      ProductFailureKind.permissionDenied => context.l10n.permissionDenied,
      ProductFailureKind.unavailable => context.l10n.networkError,
      ProductFailureKind.invalidData || ProductFailureKind.unknown => fallback,
    };
  }
}
