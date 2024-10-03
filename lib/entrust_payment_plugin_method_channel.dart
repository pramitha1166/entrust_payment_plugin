import 'package:entrust_payment_plugin/wallet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'entrust_payment_plugin_platform_interface.dart';

/// An implementation of [EntrustPaymentPluginPlatform] that uses method channels.
class MethodChannelEntrustPaymentPlugin extends EntrustPaymentPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('entrust_payment_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> initWallet() async {
    final result = await methodChannel.invokeMethod<String>('initializeWallet');
    return result;
  }

  @override
  Future<String?> provisionWallet() async {
    final result = await methodChannel.invokeMethod<String>('provisionWallet');
    return result;
  }

  @override
  Future<String?> connectWalletWithAuth(String passcode) async {
    var arguments = {"passcode": passcode};
    final result = await methodChannel.invokeMethod<String>(
        'connectWalletWithPasscode', arguments);
    return result;
  }

  @override
  Future<String?> disconnectWallet() async {
    final result = await methodChannel.invokeMethod<String>('disconnectWallet');
    return result;
  }

  @override
  Future<Wallet?> getWalletData() async {
    final result = await methodChannel.invokeMethod<String>('getWalletInfo');
    return Wallet.fromString(result ?? "");
  }

  @override
  Future<String?> clearWallet() async {
    final result = await methodChannel.invokeMethod<String>('clearWallet');
    return result;
  }

  @override
  Future<String?> logoutWallet() async {
    final result = await methodChannel.invokeMethod<String>('logoutWallet');
    return result;
  }

  @override
  Future<String?> connectWallet() async {
    final result = await methodChannel.invokeMethod<String>('connectWallet');
    return result;
  }
  
  @override
  Future<String?> enrollWallet(String? enrollData) async {
    var arguments = {"cardEnrollData": enrollData};
    final result = await methodChannel.invokeMethod<String>('enrollCard', arguments);
    return result;
  }
}
