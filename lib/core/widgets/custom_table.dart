import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class CustomTable extends StatelessWidget {
  final List<String> columnTitles;
  final List<DataRow> rows;

  const CustomTable({
    super.key,
    required this.columnTitles,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xffF0F0F0), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: DataTable(
                  columnSpacing: context.tokens.size.icon,
                  dataRowMinHeight: 20,
                  dataRowMaxHeight: 70,
                  horizontalMargin: 20,

                  headingRowColor: WidgetStateProperty.all(
                    context.tokens.color.background,
                  ),

                  columns: columnTitles
                      .map(
                        (title) => DataColumn(
                          label: Expanded(
                            child: Skeleton.keep(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  rows: rows,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
