import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const SelectBoxExampleApp());
}

class SelectBoxExampleApp extends StatelessWidget {
  const SelectBoxExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Select Box',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const SelectBoxExample(),
    );
  }
}

class SelectBoxExample extends StatefulWidget {
  const SelectBoxExample({super.key});

  @override
  State<SelectBoxExample> createState() => _SelectBoxExampleState();
}

class _SelectBoxExampleState extends State<SelectBoxExample> {
  final _formKey = GlobalKey<FormState>();
  final _singleController = BsSelectBoxController(
    options: const [
      BsSelectBoxOption(value: 1, text: Text('One')),
      BsSelectBoxOption(value: 2, text: Text('Two')),
      BsSelectBoxOption(value: 3, text: Text('Three')),
    ],
  );
  final _multipleController = BsSelectBoxController(
    multiple: true,
    options: const [
      BsSelectBoxOption(value: 'apple', text: Text('Apple')),
      BsSelectBoxOption(value: 'banana', text: Text('Banana')),
      BsSelectBoxOption(value: 'orange', text: Text('Orange')),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Box')),
      body: GestureDetector(
        onTap: SelectBoxOverlay.removeAll,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BsSelectBox(
                  controller: _singleController,
                  hintTextLabel: 'Choose a number',
                  searchable: true,
                  validators: [BsSelectValidators.required],
                ),
                const SizedBox(height: 24),
                BsSelectBox(
                  controller: _multipleController,
                  hintText: 'Choose fruit',
                  searchable: true,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => _formKey.currentState?.validate(),
                  child: const Text('Validate'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
