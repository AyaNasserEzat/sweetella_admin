import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.label,
    required this.hintText,
    this.isRequired = false,
    this.controller,
    this.validator,
    this.maxLines = 1,
    this.minLines = 1,
    this.keyboardType = TextInputType.text,
    super.key,
  });

  final String label;
  final String hintText;
  final bool isRequired;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final int minLines;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: context.tokens.text.titleSmall,
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: maxLines > 1 ? TextInputType.multiline : keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            label: Text(label, style: context.tokens.text.label),
            alignLabelWithHint: maxLines > 1,
          ),
        ),
      ],
    );
  }
}
