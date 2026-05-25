import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../providers/products_provider.dart';

class CategoryFilterChips extends ConsumerWidget {
  const CategoryFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(productCategoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: AppDimensions.chipsPadding,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spacing8),
            child: FilterChip(
              label: const Text(AppStrings.allCategories),
              selected: selectedCategory == null,
              onSelected: (_) {
                ref.read(selectedCategoryProvider.notifier).state = null;
              },
            ),
          ),
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: AppDimensions.spacing8),
              child: FilterChip(
                label: Text(category),
                selected: selectedCategory == category,
                onSelected: (_) {
                  ref.read(selectedCategoryProvider.notifier).state = category;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
