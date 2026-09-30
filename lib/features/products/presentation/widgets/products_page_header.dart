import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/core/layout/breakpoints.dart';

class ProductsPageHeader extends StatelessWidget {
  const ProductsPageHeader({required this.onAdd, super.key});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact =
            AppBreakpoints.fromWidth(constraints.maxWidth) ==
            AppBreakpoint.compact;
        return Wrap(
          spacing: tokens.space.lg,
          runSpacing: tokens.space.md,
          alignment: compact ? WrapAlignment.start : WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(context.l10n.products, style: tokens.text.display),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text(context.l10n.addProduct),
            ),
          ],
        );
      },
    );
  }
}
