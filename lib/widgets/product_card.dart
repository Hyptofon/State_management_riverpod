import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../models/product.dart';
import '../utils/currency_formatter.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProductImage(image: product.image),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimensions.spacing4),
                      Text(
                        product.category,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing8),
                      Text(
                        CurrencyFormatter.format(product.price),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: onAddToCart,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text(AppStrings.addToCart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String image;

  const _ProductImage({required this.image});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: AppDimensions.cardBorderRadius,
      ),
      child: SizedBox.square(
        dimension: AppDimensions.productImageSize,
        child: Center(
          child: Text(image, style: Theme.of(context).textTheme.headlineMedium),
        ),
      ),
    );
  }
}
