import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class ProductAddonsCount extends StatelessWidget {
  const ProductAddonsCount({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: count > 0
            ? tokens.color.brand.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Text(count.toString(), style: context.tokens.text.bodySmall),
          Text("Optional add-ons", style: context.tokens.text.bodySmall),
          //Optional add-ons
        ],
      ),
    );
  }
}
