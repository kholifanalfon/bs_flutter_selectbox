// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bs_flutter_selectbox_example/main.dart';

void main() {
  testWidgets('renders the select box example', (WidgetTester tester) async {
    await tester.pumpWidget(const SelectBoxExampleApp());

    expect(find.text('Select Box'), findsOneWidget);
    expect(find.byType(BsSelectBox), findsWidgets);
  });
}
