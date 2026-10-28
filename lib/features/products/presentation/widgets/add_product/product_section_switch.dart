import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class ProductSectionSwitch extends StatelessWidget {
  const ProductSectionSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: tokens.text.body.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle, style: tokens.text.bodySmall),
      value: value,
      activeThumbColor: tokens.color.brand,
      onChanged: onChanged,
    );
  }
}
