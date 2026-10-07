import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_cubit.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_state.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_operation_listener.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_state_view.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_dialog.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/products_page_header.dart';

class ProductsPageContent extends StatelessWidget {
  const ProductsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return ProductOperationListener(
      child: Padding(
        padding: EdgeInsets.all(tokens.space.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProductsPageHeader(onAdd: () => _openForm(context)),
            SizedBox(height: tokens.space.lg),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) => ProductStateView(
                  state: state,
                  onRetry: context.read<ProductCubit>().loadProducts,
                  onEdit: (product) => _openForm(context, product: product),
                  onDelete: (product) => _confirmDelete(context, product),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {Product? product}) async {
    final cubit = context.read<ProductCubit>();
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProductFormDialog(
        product: product,
        categories: const <ProductCategory>[],
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
}
