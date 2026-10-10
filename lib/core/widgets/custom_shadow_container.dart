import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class CustomShadowContanier extends StatelessWidget {
  const CustomShadowContanier({super.key, required this.child, this.color});
  final Widget child;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.tokens.radius.lg),
        border: Border.all(color: context.tokens.color.border),
        color: context.tokens.color.surface,
        boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(0, 1), blurRadius: 4),
        ],
      ),
      child: child,
    );
  }
}
