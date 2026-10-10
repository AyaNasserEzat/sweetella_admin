import 'package:flutter/material.dart';

class CustomShadowContanier extends StatelessWidget {
  const CustomShadowContanier({super.key, required this.child, this.color});
  final Widget child;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color ?? Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(0, 1), blurRadius: 4),
        ],
      ),
      child: child,
    );
  }
}
