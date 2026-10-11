import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class CustomShadowContanier extends StatelessWidget {
  const CustomShadowContanier({
    super.key,
    required this.child,
    this.color,
    this.width,
    this.height,
  });
  final Widget child;
  final Color? color;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.tokens.color.surface,
        borderRadius: BorderRadius.circular(context.tokens.radius.md),
        boxShadow: context.tokens.shadow.low,
      ),
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }
}
