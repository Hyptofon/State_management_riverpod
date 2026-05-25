import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../models/cart_item.dart';
import '../utils/currency_formatter.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.cardBorderRadius,
      ),
      child: Padding(
        padding: AppDimensions.cardContentPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CartProductImage(image: item.product.image),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spacing4),
                  Text(
                    CurrencyFormatter.format(item.product.price),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  Text(
                    AppStrings.subtotal(
                      CurrencyFormatter.format(item.totalPrice),
                    ),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.spacing8),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: AppStrings.removeItemTooltip,
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: onRemove,
                ),
                _QuantityStepper(
                  quantity: item.quantity,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartProductImage extends StatelessWidget {
  final String image;

  const _CartProductImage({required this.image});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: AppDimensions.cardBorderRadius,
      ),
      child: SizedBox.square(
        dimension: AppDimensions.cartImageSize,
        child: Center(
          child: Text(image, style: Theme.of(context).textTheme.headlineSmall),
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityStepper({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: AppStrings.decreaseQuantityTooltip,
          constraints: const BoxConstraints.tightFor(
            width: AppDimensions.quantityButtonSize,
            height: AppDimensions.quantityButtonSize,
          ),
          icon: const Icon(Icons.remove),
          onPressed: onDecrement,
        ),
        SizedBox(
          width: AppDimensions.quantityLabelWidth,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          tooltip: AppStrings.increaseQuantityTooltip,
          constraints: const BoxConstraints.tightFor(
            width: AppDimensions.quantityButtonSize,
            height: AppDimensions.quantityButtonSize,
          ),
          icon: const Icon(Icons.add),
          onPressed: onIncrement,
        ),
      ],
    );
  }
}
