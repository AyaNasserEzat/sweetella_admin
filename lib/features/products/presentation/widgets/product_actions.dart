import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';

class ProductActions extends StatelessWidget {
  const ProductActions({
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

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
