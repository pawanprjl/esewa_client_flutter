import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:esewa_client/esewa_client.dart';

void main() {
  const MethodChannel channel = MethodChannel('esewa_client');

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
