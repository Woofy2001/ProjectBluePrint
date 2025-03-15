import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Constructor list screen loads correctly', (
    WidgetTester tester,
  ) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app shows the title "Constructors in Sri Lanka"
    expect(find.text("Constructors in Sri Lanka"), findsOneWidget);

    // Verify that at least one constructor's name appears (modify as needed)
    expect(find.text("Nimal Perera"), findsOneWidget);

    // Verify that the search bar exists
    expect(find.byType(TextField), findsOneWidget);
  });
}
