import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/custom_text_field.dart';

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

    required this.deleteTooltip,
    required this.onDelete,
    super.key,
  });

  final ProductOptionControllers controllers;
  final bool compact;
  final String nameLabel;
  final String nameHint;

  final String deleteTooltip;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final nameField = CustomTextField(
      controller: controllers.nameController,
      label: 'name',
      hintText: 'name',
    );
    final priceField = CustomTextField(
      controller: controllers.priceController,

      keyboardType: TextInputType.number,
      label: 'price',
      hintText: 'price',
    );
    final stockField = CustomTextField(
      controller: controllers.stockController,
      keyboardType: TextInputType.number,
      label: 'stock',
      hintText: 'stock',
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: priceField),
                    SizedBox(width: tokens.space.sm),
                    Expanded(child: stockField),
                  ],
                ),
              ],
            )
          : CustomShadowContanier(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  deleteButton,
                  Expanded(flex: 2, child: nameField),
                  SizedBox(width: tokens.space.sm),
                  Expanded(child: priceField),
                  SizedBox(width: tokens.space.sm),
                  Expanded(child: stockField),
                ],
              ),
            ),
    );
  }
}
