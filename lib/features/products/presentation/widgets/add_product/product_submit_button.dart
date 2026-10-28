import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class ProductSubmitButton extends StatelessWidget {
  const ProductSubmitButton({
    required this.isEditing,
    required this.isSaving,
    required this.onPressed,
    super.key,
  });

  final bool isEditing;
  final bool isSaving;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final buttonColor = tokens.text.button.color;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: tokens.color.brand,
          foregroundColor: buttonColor,
          disabledBackgroundColor: tokens.color.textSecondary,
          padding: EdgeInsets.symmetric(vertical: tokens.space.md),
        ),
        onPressed: isSaving ? null : onPressed,
        child: isSaving
            ? SizedBox.square(
                dimension: tokens.size.icon + tokens.space.xs,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: buttonColor,
                ),
              )
            : Text(isEditing ? 'تعديل المنتج' : 'حفظ وإضافة'),
      ),
    );
  }
}
