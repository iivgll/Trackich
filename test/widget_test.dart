import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:trackich/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: TrackichApp()));
    
    // Wait for all animations and async operations to complete
    await tester.pumpAndSettle();

    // Verify that the app launches without errors by checking for essential UI elements
    expect(find.text('Current Task'), findsOneWidget);
    expect(find.text('Quick Start'), findsOneWidget);
    expect(find.text('Recent Activity'), findsOneWidget);
    
    // Verify key functionality exists
    expect(find.byType(Card), findsAtLeastNWidgets(4)); // Dashboard has multiple cards
  });
}