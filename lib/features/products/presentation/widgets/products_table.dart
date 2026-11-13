import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/cubits/upload_image_cubit.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/di/service_locator.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/core/storage/domain/use_cases/upload_image_use_case.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';
import 'package:sweetella_admin/core/widgets/custom_table.dart';
import 'package:sweetella_admin/core/widgets/delete_dialog.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/custom_cached_network_image.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_cubit.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/add_product_page.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_actions.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_addon_count.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/product_availability.dart';

class ProductsTable extends StatelessWidget {
  final List<ProductEntity> products;

  const ProductsTable({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textStyle = context.tokens.text.label;
    return CustomShadowContanier(
      child: CustomTable(
        columnTitles: [
          'Image',
          l10n.productName,
          'Sizes and Prices',
          // l10n.category,
          l10n.category,
          l10n.available,
          l10n.actions,
        ],
        rows: products.map((product) {
          return DataRow(
            cells: [
              DataCell(CustomCachedNetworkImage(imageUrl: product.imageUrl)),
              DataCell(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(product.name, style: textStyle),
                    product.addons.isNotEmpty
                        ? ProductAddonsCount(count: product.addons.length)
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              DataCell(
                product.hasVariants
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: product.variants
                            .map(
                              (e) => Row(
                                children: [
                                  Text(e.sizeName, style: textStyle),
                                  Text(
                                    ' : ${e.price.toStringAsFixed(0)} EGP',
                                    style: textStyle,
                                  ),
                                  // Text(
                                  //   '${e.stock.toStringAsFixed(0)} remain',
                                  // ),
                                ],
                              ),
                            )
                            .toList(),
                      )
                    : Text(
                        '${product.price?.toStringAsFixed(0) ?? 0} EGP',
                        style: textStyle,
                      ),
              ),
              DataCell(Text(product.categoryName, style: textStyle)),
              // DataCell(Text(product.price.toString())),
              DataCell(ProductAvailability(product: product)),
              DataCell(
                ProductActions(
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (_) =>
                                  UploadImageCubit(sl<UploadImageUseCase>()),
                            ),

                            BlocProvider(
                              create: (context) => sl<ProductCubit>(),
                            ),
                          ],

                          child: AddProductPage(productToEdit: product),
                        ),
                      ),
                    );
                  },
                  onDelete: () {
                    confirmDelete(context, product);
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
