import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class ProductOptionControllers {
  ProductOptionControllers({
    required this.id,
    required this.nameController,
    required this.priceController,
    required this.stockController,
  });

  final String id;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController stockController;

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
  }
}

class ProductOptionRow extends StatelessWidget {
  const ProductOptionRow({
    required this.controllers,
    required this.compact,
    required this.nameLabel,
    required this.nameHint,
    required this.priceLabel,
    required this.stockLabel,
    required this.deleteTooltip,
    required this.onDelete,
    super.key,
  });

  final ProductOptionControllers controllers;
  final bool compact;
  final String nameLabel;
  final String nameHint;
  final String priceLabel;
  final String stockLabel;
  final String deleteTooltip;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final nameField = TextFormField(
      controller: controllers.nameController,
      decoration: InputDecoration(
        labelText: nameLabel,
        hintText: nameHint,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
    final priceField = TextFormField(
      controller: controllers.priceController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: priceLabel,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
    final stockField = TextFormField(
      controller: controllers.stockController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: stockLabel,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
    final deleteButton = IconButton(
      tooltip: deleteTooltip,
      icon: Icon(Icons.delete_outline, color: tokens.color.danger),
      onPressed: onDelete,
    );

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: tokens.space.md),
      child: compact
          ? Column(
              children: [
                Row(
                  children: [
                    Expanded(child: nameField),
                    deleteButton,
                  ],
                ),
                SizedBox(height: tokens.space.sm),
                Row(
                  children: [
                    Expanded(child: priceField),
                    SizedBox(width: tokens.space.sm),
                    Expanded(child: stockField),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                deleteButton,
                Expanded(flex: 2, child: nameField),
                SizedBox(width: tokens.space.sm),
                Expanded(child: priceField),
                SizedBox(width: tokens.space.sm),
                Expanded(child: stockField),
              ],
            ),
    );
  }
}
