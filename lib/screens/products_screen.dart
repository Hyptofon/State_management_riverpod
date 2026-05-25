import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../utils/app_snack_bar.dart';
import '../widgets/cart_badge_button.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/empty_products_view.dart';
import '../widgets/product_card.dart';
import '../widgets/product_search_field.dart';
import 'cart_screen.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(filteredProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.productsTitle),
        actions: [
          CartBadgeButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: AppDimensions.searchFieldPadding,
              child: ProductSearchField(),
            ),
            const CategoryFilterChips(),
            const SizedBox(height: AppDimensions.spacing8),
            Expanded(
              child: products.isEmpty
                  ? const EmptyProductsView()
                  : ListView.builder(
                      padding: AppDimensions.listPadding,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppDimensions.spacing12,
                          ),
                          child: ProductCard(
                            product: product,
                            onAddToCart: () {
                              ref
                                  .read(cartProvider.notifier)
                                  .addProduct(product);
                              AppSnackBar.show(
                                context,
                                message: AppStrings.addedToCart,
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
