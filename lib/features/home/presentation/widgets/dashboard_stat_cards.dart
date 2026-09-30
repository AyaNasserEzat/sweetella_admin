import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/layout/breakpoints.dart';

class DashboardStatCards extends StatelessWidget {
  const DashboardStatCards({required this.tokens, super.key});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _MetricCardData(
        label: 'Total Revenue',
        value: 'EGP 125,450',
        delta: '+12.5%',
        description: 'from last month',
        color: tokens.color.brand,
        softColor: tokens.color.brandSoft,
        icon: Icons.attach_money_rounded,
      ),
      _MetricCardData(
        label: 'Total Orders',
        value: '1,248',
        delta: '+8.2%',
        description: 'from last month',
        color: tokens.color.success,
        softColor: tokens.color.successSoft,
        icon: Icons.receipt_rounded,
      ),
      _MetricCardData(
        label: 'Total Customers',
        value: '3,540',
        delta: '+15.4%',
        description: 'from last month',
        color: tokens.color.warning,
        softColor: tokens.color.warningSoft,
        icon: Icons.people_alt_rounded,
      ),
      _MetricCardData(
        label: 'Total Products',
        value: '128',
        delta: '+4.6%',
        description: 'from last month',
        color: tokens.color.danger,
        softColor: tokens.color.dangerSoft,
        icon: Icons.inventory_2_rounded,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = AppBreakpoints.fromWidth(constraints.maxWidth);

        final compact = breakpoint == AppBreakpoint.compact;

        if (compact) {
          return Wrap(
            spacing: tokens.space.md,
            runSpacing: tokens.space.md,
            children: stats
                .map(
                  (stat) => SizedBox(
                    width: (constraints.maxWidth - tokens.space.md) / 2,
                    child: _MetricCard(stat: stat, tokens: tokens),
                  ),
                )
                .toList(),
          );
        }

        return Row(
          children: List.generate(stats.length, (index) {
            return Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  end: index == stats.length - 1 ? 0 : tokens.space.md,
                ),
                child: _MetricCard(stat: stats[index], tokens: tokens),
              ),
            );
          }),
        );
      },
    );
  }
}

class _MetricCardData {
  const _MetricCardData({
    required this.label,
    required this.value,
    required this.delta,
    required this.description,
    required this.color,
    required this.softColor,
    required this.icon,
  });

  final String label;
  final String value;
  final String delta;
  final String description;
  final Color color;
  final Color softColor;
  final IconData icon;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.stat, required this.tokens});

  final _MetricCardData stat;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(tokens.space.lg),
      decoration: BoxDecoration(
        color: tokens.color.surface,
        borderRadius: BorderRadius.circular(tokens.radius.lg),
        boxShadow: tokens.shadow.low,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: tokens.size.profileAvatar,
                height: tokens.size.profileAvatar,
                decoration: BoxDecoration(
                  color: stat.softColor,
                  borderRadius: BorderRadius.circular(tokens.radius.lg),
                ),
                child: Center(
                  child: Icon(
                    stat.icon,
                    color: stat.color,
                    size: tokens.size.icon,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.space.sm,
                  vertical: tokens.space.xs,
                ),
                decoration: BoxDecoration(
                  color: stat.softColor,
                  borderRadius: BorderRadius.circular(tokens.radius.pill),
                ),
                child: Text(
                  stat.delta,
                  style: tokens.text.label.copyWith(color: stat.color),
                ),
              ),
            ],
          ),
          SizedBox(height: tokens.space.lg),
          Text(stat.label, style: tokens.text.bodySmall),
          SizedBox(height: tokens.space.sm),
          Text(stat.value, style: tokens.text.valueLarge),
          SizedBox(height: tokens.space.sm),
          Text(
            '${stat.delta} ${stat.description}',
            style: tokens.text.bodySmall.copyWith(color: stat.color),
          ),
        ],
      ),
    );
  }
}
