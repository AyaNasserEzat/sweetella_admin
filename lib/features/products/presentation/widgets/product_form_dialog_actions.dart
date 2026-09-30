import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';

class ProductFormDialogActions extends StatelessWidget {
  const ProductFormDialogActions({
    required this.isEditing,
    required this.isSaving,
    required this.onCancel,
    required this.onSave,
    super.key,
  });

  final bool isEditing;
  final bool isSaving;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return OverflowBar(
      alignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: isSaving ? null : onCancel,
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: isSaving ? null : onSave,
          child: isSaving
              ? SizedBox.square(
                  dimension: tokens.size.icon,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? l10n.update : l10n.save),
        ),
      ],
    );
  }
}
