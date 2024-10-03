import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:entrust_payment_plugin/entrust_payment_plugin_method_channel.dart';

void main() {
  MethodChannelEntrustPaymentPlugin platform = MethodChannelEntrustPaymentPlugin();
  const MethodChannel channel = MethodChannel('entrust_payment_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
