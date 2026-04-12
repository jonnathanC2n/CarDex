import 'package:flutter_test/flutter_test.dart';

import 'package:cardex/main.dart';

void main() {
  testWidgets('App launches test', (WidgetTester tester) async {
    await tester.pumpWidget(const CarDexApp());
  });
}
