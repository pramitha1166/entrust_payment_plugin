import 'package:entrust_payment_plugin/wallet.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'entrust_payment_plugin_method_channel.dart';

abstract class EntrustPaymentPluginPlatform extends PlatformInterface {
  /// Constructs a EntrustPaymentPluginPlatform.
  EntrustPaymentPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static EntrustPaymentPluginPlatform _instance = MethodChannelEntrustPaymentPlugin();

  /// The default instance of [EntrustPaymentPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelEntrustPaymentPlugin].
  static EntrustPaymentPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EntrustPaymentPluginPlatform] when
  /// they register themselves.
  static set instance(EntrustPaymentPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

    Future<String?> initWallet();
  Future<String?> provisionWallet();
  Future<String?> connectWalletWithAuth(String passcode);
  Future<String?> disconnectWallet();
  Future<Wallet?> getWalletData();
  Future<String?> clearWallet();
  Future<String?> logoutWallet();
  Future<String?> connectWallet();
  Future<String?> enrollWallet(String? enrollData);
}
