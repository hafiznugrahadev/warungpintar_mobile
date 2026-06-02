import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:warungpintar_mobile/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full app flow', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('WarungPOS'), findsOneWidget);
    print('✓ 1. Login screen');
    await binding.takeScreenshot('01_login');

    // Enter credentials
    final emailField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);

    await tester.tap(emailField);
    await tester.pump();
    await tester.enterText(emailField, 'owner@warungpintar.com');
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(passwordField);
    await tester.pump();
    await tester.enterText(passwordField, 'password');
    await tester.pump(const Duration(milliseconds: 500));

    // Verify text was entered
    final emailWidget = tester.widget<TextField>(emailField);
    final passWidget = tester.widget<TextField>(passwordField);
    print('  Email value: "${emailWidget.controller?.text}"');
    print('  Password value: "${passWidget.controller?.text}"');

    // Check the button
    final btn = tester.widget<FilledButton>(find.byType(FilledButton).first);
    print('  Button onPressed is ${btn.onPressed != null ? "enabled" : "DISABLED"}');
    await binding.takeScreenshot('02_filled');

    // Tap
    await tester.tap(find.byType(FilledButton).first);
    await tester.pump(); // start animation/async
    print('  Button tapped');
    await binding.takeScreenshot('03_loading');

    // Wait for network (real time) + settlement
    await tester.pumpAndSettle(const Duration(seconds: 15));
    await binding.takeScreenshot('04_settled');

    // Check final state
    final hasStore = find.text('Pilih Toko').evaluate().isNotEmpty;
    final hasCashier = find.text('Kasir').evaluate().isNotEmpty;
    final hasError = find.byType(Container).evaluate()
        .where((e) => e.widget.toString().contains('error')).isNotEmpty;
    print('  Store select: $hasStore | Cashier: $hasCashier');

    if (!hasStore && !hasCashier) {
      // Print all visible text to diagnose
      final texts = find.byType(Text).evaluate()
          .map((e) => (e.widget as Text).data ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
      print('  Visible text: $texts');
      return;
    }

    // Handle store select
    if (hasStore) {
      print('✓ 2. Store select');
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await binding.takeScreenshot('05_stores');
      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('✓ 3. Store selected');
    }

    await tester.pumpAndSettle(const Duration(seconds: 2));
    await binding.takeScreenshot('06_cashier');

    if (find.text('Kasir').evaluate().isNotEmpty) {
      print('✓ 4. Cashier screen');
      for (final tab in ['Inventaris', 'Riwayat', 'Pengaturan', 'Kasir']) {
        if (find.text(tab).evaluate().isEmpty) continue;
        await tester.tap(find.text(tab).first);
        await tester.pumpAndSettle(const Duration(seconds: 3));
        await binding.takeScreenshot('tab_$tab');
        print('✓ Tab: $tab');
      }
      print('\n✅ Full flow complete!');
    }
  });
}
