import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({required this.onSave, super.key});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return SingleChildScrollView(
      padding: EdgeInsets.all(tokens.space.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add Product', style: tokens.text.title),
          SizedBox(height: tokens.space.xl),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(tokens.space.xxl),
            decoration: BoxDecoration(
              color: tokens.color.surface,
              borderRadius: BorderRadius.circular(tokens.radius.lg),
              boxShadow: tokens.shadow.low,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Product Information', style: tokens.text.titleSmall),
                SizedBox(height: tokens.space.xl),
                const _ProductTextField(label: 'Product Name'),
                SizedBox(height: tokens.space.lg),
                const _ProductTextField(label: 'Description', maxLines: 4),
                SizedBox(height: tokens.space.lg),
                const Row(
                  children: [
                    Expanded(
                      child: _ProductTextField(
                        label: 'Price',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _ProductTextField(
                        label: 'Sale Price',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: tokens.space.xxl),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: FilledButton(
                    onPressed: onSave,
                    style: FilledButton.styleFrom(
                      backgroundColor: tokens.color.brand,
                      padding: EdgeInsets.symmetric(
                        horizontal: tokens.space.xxl,
                        vertical: tokens.space.md,
                      ),
                    ),
                    child: Text('Save Product', style: tokens.text.button),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductTextField extends StatelessWidget {
  const _ProductTextField({
    required this.label,
    this.maxLines = 1,
    this.keyboardType,
  });

  final String label;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: tokens.text.label),
        SizedBox(height: tokens.space.sm),
        TextFormField(
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: tokens.color.surfaceAlt,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.radius.md),
              borderSide: BorderSide(color: tokens.color.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.radius.md),
              borderSide: BorderSide(color: tokens.color.border),
            ),
          ),
        ),
      ],
    );
  }
}
