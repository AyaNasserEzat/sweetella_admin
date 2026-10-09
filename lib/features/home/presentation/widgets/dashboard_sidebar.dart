import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/home/presentation/widgets/sidebar_header.dart';

import 'sidebar_item.dart';
import 'sidebar_item_data.dart';
import 'sidebar_footer.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    required this.selectedDestination,
    required this.onDestinationSelected,
    super.key,
  });

  final DashboardDestination selectedDestination;
  final ValueChanged<DashboardDestination> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final items = <SidebarItemData>[
      SidebarItemData(
        label: 'Dashboard',
        icon: Icons.dashboard_rounded,
        destination: DashboardDestination.dashboard,
      ),
      SidebarItemData(
        label: context.l10n.products,
        icon: Icons.shopping_bag_rounded,
        destination: DashboardDestination.products,
      ),
      SidebarItemData(
        label: 'Categories',
        icon: Icons.category_rounded,
        destination: DashboardDestination.categories,
      ),
      SidebarItemData(label: 'Orders', icon: Icons.receipt_long_rounded),
      SidebarItemData(label: 'Customers', icon: Icons.group_rounded),
      SidebarItemData(label: 'Payments', icon: Icons.payments_rounded),
      SidebarItemData(
        label: 'Notifications',
        icon: Icons.notifications_rounded,
      ),
      SidebarItemData(label: 'Analytics', icon: Icons.bar_chart_rounded),
      SidebarItemData(label: 'Settings', icon: Icons.settings_rounded),
    ];

    return Container(
      width: tokens.size.sidebarWidth,
      color: tokens.color.surface,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(16), child: SidebarHeader()),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final item in items)
                  SidebarItem(
                    item: item,
                    active: item.destination == selectedDestination,
                    onTap: item.destination == null
                        ? null
                        : () => onDestinationSelected(item.destination!),
                  ),
              ],
            ),
          ),
          const SidebarFooter(),
        ],
      ),
    );
  }
}
