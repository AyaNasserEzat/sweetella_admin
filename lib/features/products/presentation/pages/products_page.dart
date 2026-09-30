import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/di/service_locator.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_cubit.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/products_page_content.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductCubit>()..loadProducts(),
      child: const ProductsPageContent(),
    );
  }
}
