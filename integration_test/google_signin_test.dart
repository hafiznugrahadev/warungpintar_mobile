import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:warungpintar_mobile/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Backend-driven Google button appears on login', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('WarungPOS'), findsOneWidget);
    print('✓ Login screen renders');

    // Real network fetch of GET /auth/providers — use real delays (tester.pump
    // alone advances only the fake clock and won't await real I/O).
    var found = false;
    for (int i = 0; i < 10 && !found; i++) {
      await Future<void>.delayed(const Duration(seconds: 1));
      await tester.pump();
      found = find.textContaining('Google').evaluate().isNotEmpty;
    }
    await binding.takeScreenshot('google_button');

    expect(found, isTrue,
        reason: 'Google button should render because the backend reports '
            'google enabled with a clientId');
    print('✓ Google button appeared (driven entirely by backend /auth/providers)');

    expect(find.textContaining('lanjutkan dengan'), findsWidgets);
    print('✓ "or continue with" divider present');
    print('\n✅ Backend is the source of truth for Google Sign-In');
  });
}
