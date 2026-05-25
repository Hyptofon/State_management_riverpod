import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lr11_state_management_riverpod/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows products and updates cart badge', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.text('Products'), findsOneWidget);
    expect(find.text('iPhone 14'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Add to Cart').first);
    await tester.pump();

    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Shopping Cart'), findsOneWidget);
    expect(find.text('iPhone 14'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
  });
}
