import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/error/app_failuer)localization.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_cubit.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_state.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/products_table.dart';

class ProductsPageContent extends StatelessWidget {
  const ProductsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: EdgeInsets.all(tokens.space.xl),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //ProductsPageHeader(onAdd: () => _openForm(context)),
            SizedBox(height: tokens.space.lg),

            BlocConsumer<ProductCubit, ProductState>(
              listener: (context, state) {
                if (state is ProductOperationSuccess) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                } else if (state is ProductError) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(state.failure.message(context)),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                }
              },
              builder: (context, state) {
                if (state is ProductLoading) {
                  return Skeletonizer(
                    enabled: true,
                    child: ProductsTable(
                      products: List.generate(7, (_) => ProductEntity.empty()),
                    ),
                  );
                }

                if (state is ProductLoaded) {
                  return ProductsTable(products: state.products);
                }

                if (state is ProductOperationSuccess) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductError) {
                  return Center(child: Text(state.failure.message(context)));
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> _openForm(BuildContext context, {Product? product}) async {
  //   final cubit = context.read<ProductCubit>();
  //   await showDialog<bool>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => ProductFormDialog(
  //       product: product,
  //       categories: const <ProductCategory>[],
  //       onSave: product == null ? cubit.add : cubit.update,
  //     ),
  //   );
}
