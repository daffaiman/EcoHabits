import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_application_2/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full App Test', (WidgetTester tester) async {
    // Membungkus app.main() dengan try-catch agar error Firebase di Linux 
    // tidak menghentikan jalannya pengujian otomatis.
    try {
      app.main();
    } catch (e) {
      debugPrint('Firebase initialization skipped: $e');
    }

    // Tunggu aplikasi sampai stabil (render selesai)
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verifikasi bahwa aplikasi (MaterialApp) berhasil muncul di layar
    expect(find.byType(MaterialApp), findsOneWidget);
    
    debugPrint('Integration Test Berhasil: Aplikasi terbuka.');
  });
}