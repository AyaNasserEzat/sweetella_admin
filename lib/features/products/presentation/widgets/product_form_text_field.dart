import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_form_validators.dart';

class ProductFormTextField extends StatelessWidget {
  const ProductFormTextField({
    required this.controller,
    required this.label,
    required this.enabled,
    this.required = false,
    this.keyboardType,
    this.inputFormatters,
    this.minLines,
    this.maxLines = 1,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;
  final bool required;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int? maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label),
      validator:
          validator ??
          (required
              ? (value) =>
                    ProductFormValidators.required(value, label, context.l10n)
              : null),
    );
  }
}
