import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../providers/cart_provider.dart';

class CartBadgeButton extends ConsumerWidget {
  final VoidCallback onPressed;

  const CartBadgeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider);

    return Padding(
      padding: const EdgeInsets.only(right: AppDimensions.spacing8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            tooltip: AppStrings.openCartTooltip,
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: onPressed,
          ),
          if (cartCount > 0)
            Positioned(
              right: AppDimensions.spacing4,
              top: AppDimensions.spacing4,
              child: _CartBadge(count: cartCount),
            ),
        ],
      ),
    );
  }
}

class _CartBadge extends StatelessWidget {
  final int count;

  const _CartBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final label = count > 99 ? '99+' : '$count';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.error,
        borderRadius: BorderRadius.circular(AppDimensions.badgeBorderRadius),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AppDimensions.badgeMinSize,
          minHeight: AppDimensions.badgeMinSize,
        ),
        child: Padding(
          padding: AppDimensions.badgeHorizontalPadding,
          child: Center(
            child: Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onError,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
