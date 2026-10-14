import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/features/orders/domain/entities/order_entity.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.status,
  });

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colorScheme = Theme.of(context).colorScheme;

    final Color background;
    final Color foreground;

    switch (status) {
      case OrderStatus.pending:
        background = colorScheme.tertiaryContainer;
        foreground = colorScheme.onTertiaryContainer;
      case OrderStatus.confirmed:
        background = colorScheme.secondaryContainer;
        foreground = colorScheme.onSecondaryContainer;
      case OrderStatus.preparing:
        background = colorScheme.primaryContainer;
        foreground = colorScheme.onPrimaryContainer;
      case OrderStatus.ready:
        background = colorScheme.secondaryContainer;
        foreground = colorScheme.onSecondaryContainer;
      case OrderStatus.delivered:
        background = colorScheme.primaryContainer;
        foreground = colorScheme.onPrimaryContainer;
      case OrderStatus.cancelled:
        background = colorScheme.errorContainer;
        foreground = colorScheme.onErrorContainer;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.space.sm,
        vertical: tokens.space.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(tokens.radius.md),
      ),
      child: Text(
        status.name[0].toUpperCase() + status.name.substring(1),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
