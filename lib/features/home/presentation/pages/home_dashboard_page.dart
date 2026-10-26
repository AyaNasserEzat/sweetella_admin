import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/cubits/upload_image_cubit.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/di/service_locator.dart';
import 'package:sweetella_admin/core/layout/breakpoints.dart';
import 'package:sweetella_admin/core/storage/domain/use_cases/upload_image_use_case.dart';
import 'package:sweetella_admin/features/categories/presentation/cubit/category_cubit.dart';
import 'package:sweetella_admin/features/categories/presentation/pages/categories_page.dart';
import 'package:sweetella_admin/features/orders/presentation/pages/orders_page.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_cubit.dart';
import 'package:sweetella_admin/features/products/presentation/pages/products_page.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/add_product_page.dart';
import '../widgets/sidebar_item_data.dart';
import '../widgets/dashboard_best_selling_products.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_recent_orders.dart';
import '../widgets/dashboard_sidebar.dart';
import '../widgets/dashboard_stat_cards.dart';
import '../widgets/sales_overview_card.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  DashboardDestination _selectedDestination = DashboardDestination.dashboard;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isCompact =
        AppBreakpoints.fromWidth(MediaQuery.sizeOf(context).width) ==
        AppBreakpoint.compact;

    final sidebar = DashboardSidebar(
      selectedDestination: _selectedDestination,
      onDestinationSelected: (destination) {
        setState(() => _selectedDestination = destination);
        if (isCompact) {
          Navigator.of(context).pop();
        }
      },
    );

    if (isCompact) {
      return Scaffold(
        backgroundColor: tokens.color.background,
        appBar: AppBar(
          backgroundColor: tokens.color.surface,
          title: Text(_pageTitle()),
        ),
        drawer: Drawer(child: sidebar),
        body: _selectedContent(tokens),
      );
    }

    return Scaffold(
      backgroundColor: tokens.color.background,
      body: Row(
        children: [
          SizedBox(width: tokens.size.sidebarWidth, child: sidebar),
          Expanded(child: _selectedContent(tokens)),
        ],
      ),
    );
  }

  String _pageTitle() {
    switch (_selectedDestination) {
      case DashboardDestination.dashboard:
        return 'Dashboard';
      case DashboardDestination.products:
        return 'Products';
      case DashboardDestination.addProduct:
        return 'Add Product';
      case DashboardDestination.categories:
        return 'Categories';
      case DashboardDestination.orders:
        return 'Orders';
    }
  }

  Widget _selectedContent(AppTokens tokens) {
    switch (_selectedDestination) {
      case DashboardDestination.products:
        return const ProductsPage();
      case DashboardDestination.categories:
        return const CategoriesPage();
      case DashboardDestination.addProduct:
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => UploadImageCubit(sl<UploadImageUseCase>()),
            ),
            BlocProvider(create: (context) => sl<ProductCubit>()),
            BlocProvider(
              create: (context) => sl<CategoryCubit>()..loadCategories(),
            ),
          ],

          child: const AddProductPage(),
        );
      case DashboardDestination.orders:
        return const OrdersPage();
      case DashboardDestination.dashboard:
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(tokens.space.xl),
            child: _DashboardMainContent(tokens: tokens),
          ),
        );
    }
  }
}

class _DashboardMainContent extends StatelessWidget {
  const _DashboardMainContent({required this.tokens});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardHeader(tokens: tokens),
          SizedBox(height: tokens.space.lg),
          DashboardStatCards(tokens: tokens),
          SizedBox(height: tokens.space.lg),
          SalesOverviewCard(tokens: tokens),
          SizedBox(height: tokens.space.lg),
          BestSellingProductsCard(tokens: tokens),
          SizedBox(height: tokens.space.lg),
          RecentOrdersCard(tokens: tokens),
        ],
      ),
    );
  }
}
