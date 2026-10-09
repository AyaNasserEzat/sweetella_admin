import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';

enum DashboardDestination { dashboard, products, categories }

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    required this.tokens,
    required this.compact,
    required this.selectedDestination,
    required this.onDestinationSelected,
    super.key,
  });

  final AppTokens tokens;
  final bool compact;
  final DashboardDestination selectedDestination;
  final ValueChanged<DashboardDestination> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final items = <_NavItemData>[
      _NavItemData(
        label: 'Dashboard',
        icon: Icons.dashboard_rounded,
        destination: DashboardDestination.dashboard,
      ),
      _NavItemData(
        label: context.l10n.products,
        icon: Icons.shopping_bag_rounded,
        destination: DashboardDestination.products,
      ),
      _NavItemData(
        label: 'Categories',
        icon: Icons.category_rounded,
        destination: DashboardDestination.categories,
      ),
      _NavItemData(label: 'Orders', icon: Icons.receipt_long_rounded),
      _NavItemData(label: 'Customers', icon: Icons.group_rounded),
      _NavItemData(label: 'Payments', icon: Icons.payments_rounded),
      _NavItemData(label: 'Notifications', icon: Icons.notifications_rounded),
      _NavItemData(label: 'Analytics', icon: Icons.bar_chart_rounded),
      _NavItemData(label: 'Settings', icon: Icons.settings_rounded),
    ];

    return compact ? _buildCompact(items) : _buildExpanded(items);
  }

  Widget _buildCompact(List<_NavItemData> items) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.space.md,
        vertical: tokens.space.sm,
      ),
      decoration: BoxDecoration(
        color: tokens.color.surface,
        border: Border(bottom: BorderSide(color: tokens.color.border)),
      ),
      child: Row(
        children: [
          _buildBrand(),
          SizedBox(width: tokens.space.md),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: items
                    .map(
                      (item) => Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: tokens.space.xs,
                        ),
                        child: _buildCompactNavItem(
                          item,
                          item.destination == selectedDestination,
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpanded(List<_NavItemData> items) {
    return Container(
      width: tokens.size.sidebarWidth,
      padding: EdgeInsets.all(tokens.space.lg),
      decoration: BoxDecoration(
        color: tokens.color.surface,
        border: BorderDirectional(end: BorderSide(color: tokens.color.border)),
      ),
      child: Column(
        children: [
          _buildBrand(),
          SizedBox(height: tokens.space.xl),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: items
                  .map((item) {
                    final active = item.destination == selectedDestination;
                    return Padding(
                      padding: EdgeInsets.only(bottom: tokens.space.sm),
                      child: _buildExpandedNavItem(item, active),
                    );
                  })
                  .toList(growable: false),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(tokens.radius.md),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: tokens.space.md,
                vertical: tokens.space.sm,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.logout_rounded,
                    color: tokens.color.textSecondary,
                    size: tokens.size.icon,
                  ),
                  SizedBox(width: tokens.space.sm),
                  Text(
                    'Logout',
                    style: tokens.text.body.copyWith(
                      color: tokens.color.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrand() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: tokens.size.profileAvatar,
          height: tokens.size.profileAvatar,
          decoration: BoxDecoration(
            color: tokens.color.brandSoft,
            borderRadius: BorderRadius.circular(tokens.radius.xl),
          ),
          child: Center(
            child: Icon(
              Icons.cake_rounded,
              color: tokens.color.brand,
              size: tokens.size.icon,
            ),
          ),
        ),
        if (!compact) ...[
          SizedBox(width: tokens.space.md),
          Flexible(
            child: Text(
              'Sweetella',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.text.title,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildExpandedNavItem(_NavItemData item, bool active) {
    return Tooltip(
      message: item.label,
      child: AnimatedContainer(
        duration: tokens.motion.short,
        decoration: BoxDecoration(
          color: active ? tokens.color.brandSoft : null,
          borderRadius: BorderRadius.circular(tokens.radius.md),
        ),
        child: ListTile(
          dense: true,
          selected: active,
          onTap: item.destination == null
              ? null
              : () => onDestinationSelected(item.destination!),
          contentPadding: EdgeInsets.symmetric(horizontal: tokens.space.md),
          leading: Icon(
            item.icon,
            color: active ? tokens.color.brand : tokens.color.textSecondary,
            size: tokens.size.icon,
          ),
          title: Text(
            item.label,
            style: active
                ? tokens.text.titleSmall.copyWith(color: tokens.color.brand)
                : tokens.text.body.copyWith(color: tokens.color.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactNavItem(_NavItemData item, bool active) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: active ? tokens.color.brandSoft : null,
        borderRadius: BorderRadius.circular(tokens.radius.md),
      ),
      child: IconButton(
        tooltip: item.label,
        onPressed: item.destination == null
            ? null
            : () => onDestinationSelected(item.destination!),
        color: active ? tokens.color.brand : tokens.color.textSecondary,
        icon: Icon(item.icon, size: tokens.size.icon),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.label,
    required this.icon,
    this.destination,
  });

  final String label;
  final IconData icon;
  final DashboardDestination? destination;
}
