import 'package:flutter_test/flutter_test.dart';
import 'package:entrust_payment_plugin/entrust_payment_plugin.dart';
import 'package:entrust_payment_plugin/entrust_payment_plugin_platform_interface.dart';
import 'package:entrust_payment_plugin/entrust_payment_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEntrustPaymentPluginPlatform
    with MockPlatformInterfaceMixin
    implements EntrustPaymentPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final EntrustPaymentPluginPlatform initialPlatform = EntrustPaymentPluginPlatform.instance;

  test('$MethodChannelEntrustPaymentPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEntrustPaymentPlugin>());
  });

  test('getPlatformVersion', () async {
    EntrustPaymentPlugin entrustPaymentPlugin = EntrustPaymentPlugin();
    MockEntrustPaymentPluginPlatform fakePlatform = MockEntrustPaymentPluginPlatform();
    EntrustPaymentPluginPlatform.instance = fakePlatform;

    expect(await entrustPaymentPlugin.getPlatformVersion(), '42');
  });
}
