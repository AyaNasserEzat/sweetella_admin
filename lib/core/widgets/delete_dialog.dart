import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_cubit.dart';

Future<void> confirmDelete(BuildContext context, ProductEntity product) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.deleteProductTitle),
      content: Text('Are you sure you want to delete ${product.name}?'),
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
    await context.read<ProductCubit>().deleteProduct(product.id);
  }
}
