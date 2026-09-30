import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/di/service_locator.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/core/layout/breakpoints.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
import 'package:sweetella_admin/features/products/domain/errors/product_failure.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_cubit.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_state.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_dialog.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_list_item.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductCubit>()..loadProducts(),
      child: const _ProductsPageView(),
    );
  }
}

class _ProductsPageView extends StatelessWidget {
  const _ProductsPageView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductCubit, ProductState>(
      listener: (context, state) {
        final message = _actionMessage(context, state);
        if (message != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
        }
      },
      child: Padding(
        padding: EdgeInsets.all(context.tokens.space.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProductsHeader(onAdd: () => _openForm(context)),
            SizedBox(height: context.tokens.space.lg),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) => _buildState(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildState(BuildContext context, ProductState state) {
    return switch (state) {
      ProductInitial() ||
      ProductLoading() => const Center(child: CircularProgressIndicator()),
      ProductLoadError(:final failure) => _LoadError(
        message: _failureMessage(
          context,
          failure,
          context.l10n.productsLoadError,
        ),
        onRetry: context.read<ProductCubit>().loadProducts,
      ),
      ProductDataState() =>
        state.products.isEmpty
            ? const _EmptyProducts()
            : _ProductList(
                products: state.products,
                categories: state.categories,
                onEdit: (product) => _openForm(context, product: product),
                onDelete: (product) => _confirmDelete(context, product),
              ),
    };
  }

  Future<void> _openForm(BuildContext context, {Product? product}) async {
    final cubit = context.read<ProductCubit>();
    final data = cubit.state is ProductDataState
        ? cubit.state as ProductDataState
        : null;
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProductFormDialog(
        product: product,
        categories: data?.categories ?? const <ProductCategory>[],
        onSave: product == null ? cubit.add : cubit.update,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Product product) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteProductTitle),
        content: Text(l10n.deleteProductMessage(product.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.deleteProduct),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<ProductCubit>().delete(product.id);
    }
  }

  String? _actionMessage(BuildContext context, ProductState state) {
    final l10n = context.l10n;
    return switch (state) {
      ProductAddSuccess() => l10n.productAdded,
      ProductUpdateSuccess() => l10n.productUpdated,
      ProductDeleteSuccess() => l10n.productDeleted,
      ProductAddError(:final failure) => _failureMessage(
        context,
        failure,
        l10n.productAddError,
      ),
      ProductUpdateError(:final failure) => _failureMessage(
        context,
        failure,
        l10n.productUpdateError,
      ),
      ProductDeleteError(:final failure) => _failureMessage(
        context,
        failure,
        l10n.productDeleteError,
      ),
      _ => null,
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

class _ProductsHeader extends StatelessWidget {
  const _ProductsHeader({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact =
            AppBreakpoints.fromWidth(constraints.maxWidth) ==
            AppBreakpoint.compact;
        return Wrap(
          spacing: tokens.space.lg,
          runSpacing: tokens.space.md,
          alignment: compact ? WrapAlignment.start : WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(context.l10n.products, style: tokens.text.display),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text(context.l10n.addProduct),
            ),
          ],
        );
      },
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_outlined, color: tokens.color.danger),
          SizedBox(height: tokens.space.md),
          Text(message, style: tokens.text.body, textAlign: TextAlign.center),
          SizedBox(height: tokens.space.md),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: tokens.color.textSecondary,
            size: tokens.size.icon * 2,
          ),
          SizedBox(height: tokens.space.md),
          Text(context.l10n.productsEmpty, style: tokens.text.titleSmall),
        ],
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({
    required this.products,
    required this.categories,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Product> products;
  final List<ProductCategory> categories;
  final ValueChanged<Product> onEdit;
  final ValueChanged<Product> onDelete;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact =
            AppBreakpoints.fromWidth(constraints.maxWidth) ==
            AppBreakpoint.compact;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!compact) ...[
              _ProductTableHeader(tokens: tokens),
              SizedBox(height: tokens.space.sm),
            ],
            Expanded(
              child: ListView.separated(
                itemCount: products.length,
                padding: EdgeInsets.only(bottom: tokens.space.xl),
                separatorBuilder: (context, index) =>
                    SizedBox(height: tokens.space.sm),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final category = categories
                      .where((item) => item.id == product.categoryId)
                      .firstOrNull;
                  return ProductListItem(
                    key: ValueKey(product.id),
                    product: product,
                    categoryName:
                        category?.name ?? context.l10n.unknownCategory,
                    compact: compact,
                    onEdit: () => onEdit(product),
                    onDelete: () => onDelete(product),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProductTableHeader extends StatelessWidget {
  const _ProductTableHeader({required this.tokens});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: tokens.space.md,
        end: tokens.space.md,
        bottom: tokens.space.xs,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(context.l10n.productName, style: tokens.text.label),
          ),
          Expanded(
            flex: 2,
            child: Text(context.l10n.category, style: tokens.text.label),
          ),
          Expanded(
            flex: 2,
            child: Text(context.l10n.price, style: tokens.text.label),
          ),
          Expanded(
            flex: 2,
            child: Text(context.l10n.available, style: tokens.text.label),
          ),
          SizedBox(
            width: tokens.size.profileAvatar * 2,
            child: Text(context.l10n.actions, style: tokens.text.label),
          ),
        ],
      ),
    );
  }
}
