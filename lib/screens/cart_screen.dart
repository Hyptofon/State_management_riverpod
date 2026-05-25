import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../providers/cart_provider.dart';
import '../utils/app_snack_bar.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/checkout_summary.dart';
import '../widgets/empty_cart_view.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartItemsProvider);
    final cartCount = ref.watch(cartCountProvider);
    final cartTotal = ref.watch(cartTotalProvider);
    final isLoading = ref.watch(cartIsLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.cartTitle),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              tooltip: AppStrings.clearCartTooltip,
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                ref.read(cartProvider.notifier).clear();
                AppSnackBar.show(context, message: AppStrings.cartCleared);
              },
            ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : cartItems.isEmpty
            ? const EmptyCartView()
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: AppDimensions.listPadding,
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];

                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppDimensions.spacing12,
                          ),
                          child: Dismissible(
                            key: ValueKey(item.product.id),
                            direction: DismissDirection.endToStart,
                            background: const _CartDismissBackground(),
                            onDismissed: (_) {
                              ref
                                  .read(cartProvider.notifier)
                                  .removeProduct(item.product.id);
                              AppSnackBar.show(
                                context,
                                message: AppStrings.removedFromCart,
                              );
                            },
                            child: CartItemTile(
                              item: item,
                              onIncrement: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .incrementProduct(item.product.id);
                              },
                              onDecrement: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .decrementProduct(item.product.id);
                              },
                              onRemove: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .removeProduct(item.product.id);
                                AppSnackBar.show(
                                  context,
                                  message: AppStrings.removedFromCart,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  CheckoutSummary(
                    itemCount: cartCount,
                    total: cartTotal,
                    onCheckout: () {
                      AppSnackBar.show(
                        context,
                        message: AppStrings.checkoutReady,
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class _CartDismissBackground extends StatelessWidget {
  const _CartDismissBackground();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: AppDimensions.cardBorderRadius,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: AppDimensions.spacing20),
          child: Icon(
            Icons.delete_outline,
            color: colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }
}
