import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';

final productsProvider = Provider<List<Product>>((ref) {
  return List.unmodifiable([
    Product(
      id: 'iphone-14',
      name: 'iPhone 14',
      price: 999.99,
      category: 'Electronics',
      image: '📱',
    ),
    Product(
      id: 'macbook-pro',
      name: 'MacBook Pro',
      price: 1999.99,
      category: 'Electronics',
      image: '💻',
    ),
    Product(
      id: 'apple-watch',
      name: 'Apple Watch',
      price: 399.99,
      category: 'Electronics',
      image: '⌚',
    ),
    Product(
      id: 'wireless-headphones',
      name: 'Wireless Headphones',
      price: 249.99,
      category: 'Electronics',
      image: '🎧',
    ),
    Product(
      id: 'cotton-hoodie',
      name: 'Cotton Hoodie',
      price: 79.99,
      category: 'Clothing',
      image: '🧥',
    ),
    Product(
      id: 'running-sneakers',
      name: 'Running Sneakers',
      price: 129.99,
      category: 'Clothing',
      image: '👟',
    ),
    Product(
      id: 'dart-handbook',
      name: 'Dart Handbook',
      price: 34.99,
      category: 'Books',
      image: '📘',
    ),
    Product(
      id: 'clean-code-guide',
      name: 'Clean Code Guide',
      price: 44.99,
      category: 'Books',
      image: '📗',
    ),
    Product(
      id: 'daily-backpack',
      name: 'Daily Backpack',
      price: 89.99,
      category: 'Accessories',
      image: '🎒',
    ),
    Product(
      id: 'desk-lamp',
      name: 'Desk Lamp',
      price: 59.99,
      category: 'Home',
      image: '💡',
    ),
  ]);
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final productCategoriesProvider = Provider<List<String>>((ref) {
  final products = ref.watch(productsProvider);
  final categories =
      products.map((product) => product.category).toSet().toList()..sort();

  return List.unmodifiable(categories);
});

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider).trim().toLowerCase();

  final filteredProducts = products.where((product) {
    final matchesCategory =
        selectedCategory == null || product.category == selectedCategory;
    final matchesSearch =
        searchQuery.isEmpty || product.name.toLowerCase().contains(searchQuery);

    return matchesCategory && matchesSearch;
  }).toList();

  return List.unmodifiable(filteredProducts);
});