import 'package:flutter_test/flutter_test.dart';

import 'package:poke_battle/main.dart';

void main() {
  testWidgets('start screen is shown', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('ポケモンタイプじゃんけん'), findsOneWidget);
    expect(find.text('スタート'), findsOneWidget);
  });
}
