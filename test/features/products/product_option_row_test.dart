import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sweetella_admin/core/theme/app_theme.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/add_product/product_option_row.dart';

void main() {
  testWidgets('renders and deletes an option in compact RTL layout', (
    tester,
  ) async {
    final controllers = _createControllers();
    addTearDown(controllers.dispose);
    var wasDeleted = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: SingleChildScrollView(
                child: ProductOptionRow(
                  controllers: controllers,
                  compact: true,
                  nameLabel: 'Size',
                  nameHint: 'Large',
                  priceLabel: 'Price',
                  stockLabel: 'Stock',
                  deleteTooltip: 'Delete option',
                  onDelete: () => wasDeleted = true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Size'), findsOneWidget);
    expect(find.text('Price'), findsOneWidget);
    expect(find.text('Stock'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Delete option'));
    await tester.pump();

    expect(wasDeleted, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders the expanded option row', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controllers = _createControllers();
    addTearDown(controllers.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ProductOptionRow(
            controllers: controllers,
            compact: false,
            nameLabel: 'Size',
            nameHint: 'Large',
            priceLabel: 'Price',
            stockLabel: 'Stock',
            deleteTooltip: 'Delete option',
            onDelete: () {},
          ),
        ),
      ),
    );

    expect(find.text('Size'), findsOneWidget);
    expect(find.text('Price'), findsOneWidget);
    expect(find.text('Stock'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

ProductOptionControllers _createControllers() {
  return ProductOptionControllers(
    id: 'option-id',
    nameController: TextEditingController(),
    priceController: TextEditingController(),
    stockController: TextEditingController(),
  );
}
