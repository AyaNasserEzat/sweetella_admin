import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class RecentOrdersCard extends StatelessWidget {
  const RecentOrdersCard({required this.tokens, super.key});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _OrderRow(
        id: 'ORD-1024',
        customer: 'Alicia',
        product: 'Chocolate Donut',
        total: 'EGP 480',
        status: 'Paid',
      ),
      _OrderRow(
        id: 'ORD-1023',
        customer: 'Hassan',
        product: 'Lotus Cheesecake',
        total: 'EGP 680',
        status: 'Pending',
      ),
      _OrderRow(
        id: 'ORD-1022',
        customer: 'Sara',
        product: 'Strawberry Cake',
        total: 'EGP 740',
        status: 'Delivered',
      ),
      _OrderRow(
        id: 'ORD-1021',
        customer: 'Noah',
        product: 'Red Velvet Cake',
        total: 'EGP 560',
        status: 'Processing',
      ),
      _OrderRow(
        id: 'ORD-1020',
        customer: 'Maya',
        product: 'Mini Dessert Box',
        total: 'EGP 890',
        status: 'Paid',
      ),
    ];

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
              Text('Recent Orders', style: tokens.text.titleSmall),
              const Spacer(),
              Text(
                'View all',
                style: tokens.text.bodySmall.copyWith(
                  color: tokens.color.brand,
                ),
              ),
            ],
          ),
          SizedBox(height: tokens.space.lg),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 0),
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(110),
                  1: FixedColumnWidth(120),
                  2: FixedColumnWidth(170),
                  3: FixedColumnWidth(100),
                  4: FixedColumnWidth(110),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: tokens.color.surfaceAlt),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Order ID'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Customer'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Product'),
                      ),
                      Padding(padding: EdgeInsets.all(8), child: Text('Total')),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Status'),
                      ),
                    ],
                  ),
                  ...rows.map((row) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(row.id, style: tokens.text.body),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(row.customer, style: tokens.text.body),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(row.product, style: tokens.text.body),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(row.total, style: tokens.text.body),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: _StatusBadge(
                            status: row.status,
                            tokens: tokens,
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderRow {
  const _OrderRow({
    required this.id,
    required this.customer,
    required this.product,
    required this.total,
    required this.status,
  });

  final String id;
  final String customer;
  final String product;
  final String total;
  final String status;
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.tokens});

  final String status;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final background = _statusBackground(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.space.sm,
        vertical: tokens.space.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(tokens.radius.pill),
      ),
      child: Text(status, style: tokens.text.label.copyWith(color: color)),
    );
  }

  Color _statusColor(String value) {
    switch (value) {
      case 'Paid':
        return tokens.color.success;
      case 'Pending':
        return tokens.color.warning;
      case 'Delivered':
        return tokens.color.brand;
      case 'Processing':
        return tokens.color.info;
      default:
        return tokens.color.textSecondary;
    }
  }

  Color _statusBackground(String value) {
    switch (value) {
      case 'Paid':
        return tokens.color.successSoft;
      case 'Pending':
        return tokens.color.warningSoft;
      case 'Delivered':
        return tokens.color.brandSoft;
      case 'Processing':
        return tokens.color.infoSoft;
      default:
        return tokens.color.surfaceAlt;
    }
  }
}
