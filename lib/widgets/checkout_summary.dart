import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../utils/currency_formatter.dart';

class CheckoutSummary extends StatelessWidget {
  final int itemCount;
  final double total;
  final VoidCallback onCheckout;

  const CheckoutSummary({
    super.key,
    required this.itemCount,
    required this.total,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        ),
        child: Padding(
          padding: AppDimensions.summaryPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppStrings.itemsLabel, style: theme.textTheme.bodyLarge),
                  Text(
                    '$itemCount',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.totalLabel,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      CurrencyFormatter.format(total),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing16),
              FilledButton.icon(
                onPressed: onCheckout,
                icon: const Icon(Icons.payment),
                label: const Text(AppStrings.checkoutButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
