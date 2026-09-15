import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('renders with Material UI', (tester) async {
    final controller = BsSelectBoxController(
      options: const [
        BsSelectBoxOption(value: 1, text: Text('One')),
        BsSelectBoxOption(value: 2, text: Text('Two')),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BsSelectBox(
            controller: controller,
            hintText: 'Choose an option',
          ),
        ),
      ),
    );

    expect(find.text('Choose an option'), findsOneWidget);

    await tester.tap(find.text('Choose an option'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('One'));
    await tester.pumpAndSettle();

    expect(controller.getSelected()?.getValue(), 1);
    expect(find.text('One'), findsOneWidget);
  });
}
