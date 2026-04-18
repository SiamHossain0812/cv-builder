import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cv_builder/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    // Basic smoke test — just verifies the widget tree builds
    await tester.pumpWidget(
      const ProviderScope(child: CVStudioApp()),
    );
  });
}
