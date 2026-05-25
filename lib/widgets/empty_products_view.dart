import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';

class EmptyProductsView extends StatelessWidget {
  const EmptyProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: AppDimensions.emptyStatePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: AppDimensions.emptySearchIconSize,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              AppStrings.noProductsFound,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
