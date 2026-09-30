import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/core/layout/breakpoints.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_attribute_form_data.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_data.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_dialog_content.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_option_form_data.dart';

part 'product_form_dialog_state.dart';

class ProductFormDialog extends StatefulWidget {
  const ProductFormDialog({
    required this.categories,
    required this.onSave,
    this.product,
    super.key,
  });

  final List<ProductCategory> categories;
  final Product? product;
  final Future<bool> Function(Product product) onSave;

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}
