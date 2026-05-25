import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../providers/products_provider.dart';

class ProductSearchField extends ConsumerStatefulWidget {
  const ProductSearchField({super.key});

  @override
  ConsumerState<ProductSearchField> createState() => _ProductSearchFieldState();
}

class _ProductSearchFieldState extends ConsumerState<ProductSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(searchQueryProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);

    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        labelText: AppStrings.searchProducts,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchQuery.isEmpty
            ? null
            : IconButton(
                tooltip: AppStrings.clearSearchTooltip,
                icon: const Icon(Icons.close),
                onPressed: () {
                  _controller.clear();
                  ref.read(searchQueryProvider.notifier).state = '';
                },
              ),
        border: OutlineInputBorder(
          borderRadius: AppDimensions.cardBorderRadius,
        ),
      ),
      onChanged: (value) {
        ref.read(searchQueryProvider.notifier).state = value;
      },
    );
  }
}
