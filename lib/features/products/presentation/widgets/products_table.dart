import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/cubits/upload_image_cubit.dart';
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
import 'package:sweetella_admin/features/products/presentation/widgets/product_availability.dart';

class ProductsTable extends StatelessWidget {
  final List<ProductEntity> products;

  const ProductsTable({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return CustomShadowContanier(
      child: CustomTable(
        columnTitles: [
          'Image',
          l10n.productName,
          // l10n.category,
          l10n.price,
          l10n.available,
          l10n.actions,
        ],
        rows: products.map((product) {
          return DataRow(
            cells: [
              DataCell(CustomCachedNetworkImage(imageUrl: product.imageUrl)),
              DataCell(Text(product.name)),
              DataCell(Text(product.categoryName)),
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
