import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/utils/app_colors.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';

void showOverlayMessage({
  required BuildContext context,
  required String text,
  bool isError = false,
}) {
  final overlay = Overlay.of(context);

  final entry = OverlayEntry(
    builder: (context) {
      return Positioned(
        bottom: 80,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: CustomShadowContanier(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      isError
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle,
                      color: isError ? Colors.red : Colors.greenAccent,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(text, style: context.tokens.text.body),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(entry);

  Future.delayed(const Duration(seconds: 2), () {
    entry.remove();
  });
}
