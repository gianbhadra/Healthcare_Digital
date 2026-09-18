import 'package:flutter_test/flutter_test.dart';
import 'package:healthcare_digital/main.dart';

void main() {
  testWidgets('HealthCareApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HealthCareApp());
    expect(find.text('HealthCare Digital'), findsWidgets);
  });
}
