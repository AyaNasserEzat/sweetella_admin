import 'package:flutter/material.dart';

enum DashboardDestination { dashboard, products, categories }

class SidebarItemData {
  const SidebarItemData({
    required this.label,
    required this.icon,
    this.destination,
  });

  final String label;
  final IconData icon;
  final DashboardDestination? destination;
}
