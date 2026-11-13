import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/layout/breakpoints.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/custom_text_field.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/image_upload_box.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/add_product/product_category_field.dart';

class ProductIdentitySection extends StatefulWidget {
  ProductIdentitySection({
    required this.breakpoint,
    required this.nameController,
    required this.descriptionController,
    required this.selectedCategoryId,
    required this.selectedCategoryName,
    required this.imagePath,
    required this.onImageTap,
    required this.onCategorySelected,
    super.key,
  });

  final AppBreakpoint breakpoint;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  String? selectedCategoryId;
  String? selectedCategoryName;
  final String? imagePath;
  final VoidCallback onImageTap;
  final void Function(String id, String name) onCategorySelected;

  @override
  State<ProductIdentitySection> createState() => _ProductIdentitySectionState();
}

class _ProductIdentitySectionState extends State<ProductIdentitySection> {
  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final nameField = CustomTextField(
      label: 'Product name',
      hintText: 'Product name',
      isRequired: true,
      controller: widget.nameController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Product name is required';
        }
        return null;
      },
    );
    final categoryField = ProductCategoryField(
      selectedCategoryId: widget.selectedCategoryId,
      onSelected: widget.onCategorySelected,
    );
    final imageUpload = ImageUploadBox(
      imagePath: widget.imagePath,
      onTap: widget.onImageTap,
    );

    final descriptionField = CustomTextField(
      label: 'Description',
      hintText: 'Description',
      isRequired: true,
      controller: widget.descriptionController,
      minLines: 4,
      maxLines: 6,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Description is required';
        }
        return null;
      },
    );

    if (widget.breakpoint == AppBreakpoint.expanded) {
      return CustomShadowContanier(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                spacing: tokens.space.md,
                children: [nameField, categoryField, descriptionField],
              ),
            ),
            SizedBox(width: tokens.space.xxl),
            SizedBox(width: 450, child: imageUpload),
          ],
        ),
      );
    }
    return CustomShadowContanier(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: imageUpload,
            ),
          ),
          SizedBox(height: tokens.space.lg),
          nameField,
          SizedBox(height: tokens.space.md),
          categoryField,
          SizedBox(height: tokens.space.md),
          descriptionField,
        ],
      ),
    );
  }
}
