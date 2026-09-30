import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class SalesOverviewCard extends StatefulWidget {
  const SalesOverviewCard({required this.tokens, super.key});
  final AppTokens tokens;
  @override
  State<SalesOverviewCard> createState() => _SalesOverviewCardState();
}

class _SalesOverviewCardState extends State<SalesOverviewCard> {
  final filters = ['Weekly', 'Monthly', 'Yearly'];
  String selectedFilter = 'Monthly';
  AppTokens get tokens => widget.tokens;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tokens.space.lg),
      decoration: BoxDecoration(
        color: tokens.color.surface,
        borderRadius: BorderRadius.circular(tokens.radius.lg),
        boxShadow: tokens.shadow.low,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sales Overview', style: tokens.text.title),
          SizedBox(height: tokens.space.md),
          Wrap(
            spacing: tokens.space.sm,
            runSpacing: tokens.space.xs,
            children: filters.map((filter) {
              final selected = filter == selectedFilter;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: tokens.space.md,
                    vertical: tokens.space.xs,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? tokens.color.brand
                        : tokens.color.surfaceAlt,
                    borderRadius: BorderRadius.circular(tokens.radius.pill),
                  ),
                  child: Text(
                    filter,
                    style: tokens.text.chip.copyWith(
                      color: selected
                          ? tokens.color.surface
                          : tokens.color.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: tokens.space.lg),
          SizedBox(
            width: double.infinity,
            height: tokens.size.chartHeight,
            child: CustomPaint(
              painter: _SalesChartPainter(
                values: const [18, 28, 21, 37, 31, 54, 49, 68, 62, 80, 71, 92],
                fillColor: tokens.color.brand.withValues(alpha: 0.12),
                lineColor: tokens.color.brand,
                gridColor: tokens.color.border,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesChartPainter extends CustomPainter {
  const _SalesChartPainter({
    required this.values,
    required this.fillColor,
    required this.lineColor,
    required this.gridColor,
  });
  final List<double> values;
  final Color fillColor;
  final Color lineColor;
  final Color gridColor;
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }
    final gridPaint = Paint()..color = gridColor;
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fillPaint = Paint()..color = fillColor;
    for (var i = 0; i <= 4; i++) {
      final top = size.height * (i / 4);
      canvas.drawLine(Offset(0, top), Offset(size.width, top), gridPaint);
    }
    final maxValue = values.reduce((a, b) => a > b ? a : b) * 1.2;
    final points = <Offset>[];
    for (var index = 0; index < values.length; index++) {
      final x = (size.width / (values.length - 1)) * index;
      final y = size.height - (values[index] / maxValue) * size.height;
      points.add(Offset(x, y));
    }
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SalesChartPainter oldDelegate) {
    return values != oldDelegate.values ||
        fillColor != oldDelegate.fillColor ||
        lineColor != oldDelegate.lineColor ||
        gridColor != oldDelegate.gridColor;
  }
}
