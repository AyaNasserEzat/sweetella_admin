import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/layout/breakpoints.dart';

class BestSellingProductsCard extends StatelessWidget {
  const BestSellingProductsCard({required this.tokens, super.key});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final hasSidebar = viewportWidth >= AppBreakpoints.compactMax;
    final contentWidth = hasSidebar
        ? viewportWidth - tokens.size.sidebarWidth - tokens.space.xl * 2
        : viewportWidth - tokens.space.xl * 2;
    final breakpoint = AppBreakpoints.fromWidth(contentWidth);
    final crossAxisCount = switch (breakpoint) {
      AppBreakpoint.compact => 2,
      AppBreakpoint.medium => 3,
      AppBreakpoint.expanded => 4,
    };
    final products = [
      _ProductData(
        name: 'Chocolate Donut',
        sales: '1.8K sales',
        price: 'EGP 320',
        image:
            'https://images.unsplash.com/photo-1551024601-bec78aea704b?auto=format&fit=crop&w=800&q=80',
      ),
      _ProductData(
        name: 'Lotus Cheesecake',
        sales: '1.3K sales',
        price: 'EGP 540',
        image:
            'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?auto=format&fit=crop&w=800&q=80',
      ),
      _ProductData(
        name: 'Strawberry Cake',
        sales: '1.1K sales',
        price: 'EGP 430',
        image:
            'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=800&q=80',
      ),
      _ProductData(
        name: 'Red Velvet Cake',
        sales: '980 sales',
        price: 'EGP 500',
        image:
            'https://images.unsplash.com/photo-1558301211-0d8c8ddee6ec?auto=format&fit=crop&w=800&q=80',
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
          Text('Best Selling Products', style: tokens.text.title),
          SizedBox(height: tokens.space.lg),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: tokens.space.md,
              crossAxisSpacing: tokens.space.md,
              childAspectRatio: 0.82,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _ProductTile(product: products[index], tokens: tokens);
            },
          ),
        ],
      ),
    );
  }
}

class _ProductData {
  const _ProductData({
    required this.name,
    required this.sales,
    required this.price,
    required this.image,
  });

  final String name;
  final String sales;
  final String price;
  final String image;
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.tokens});

  final _ProductData product;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tokens.color.surface,
        borderRadius: BorderRadius.circular(tokens.radius.lg),
        border: Border.all(color: tokens.color.border),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(tokens.radius.lg),
              topRight: Radius.circular(tokens.radius.lg),
            ),
            child: Image.network(
              product.image,
              height: tokens.size.productImageHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(tokens.space.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: tokens.text.titleSmall),
                SizedBox(height: tokens.space.xs),
                Text(product.sales, style: tokens.text.bodySmall),
                SizedBox(height: tokens.space.sm),
                Text(
                  product.price,
                  style: tokens.text.amount.copyWith(color: tokens.color.brand),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
