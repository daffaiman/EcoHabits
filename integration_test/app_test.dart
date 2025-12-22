import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Pastikan import ini mengarah ke main.dart project Anda
import 'package:flutter_application_2/main.dart' as app; 

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full App Test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}