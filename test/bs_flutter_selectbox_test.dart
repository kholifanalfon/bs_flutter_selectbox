import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';

void main() {
  const MethodChannel channel = MethodChannel('bs_flutter_selectbox');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
