import 'package:entrust_payment_plugin/wallet.dart';

import 'entrust_payment_plugin_platform_interface.dart';

class EntrustPaymentPlugin {
  Future<String?> getPlatformVersion() {
    return EntrustPaymentPluginPlatform.instance.getPlatformVersion();
  }

  Future<String?> initWallet() {
    return EntrustPaymentPluginPlatform.instance.initWallet();
  }

  Future<String?> provisionWallet() {
    return EntrustPaymentPluginPlatform.instance.provisionWallet();
  }

  Future<String?> connectWalletWithAuth(String passcode) {
    return EntrustPaymentPluginPlatform.instance
        .connectWalletWithAuth(passcode);
  }

  Future<String?> disconnectWallet() {
    return EntrustPaymentPluginPlatform.instance.disconnectWallet();
  }

  Future<Wallet?> getWalletInfo() {
    return EntrustPaymentPluginPlatform.instance.getWalletData();
  }

  Future<String?> clearWallet() {
    return EntrustPaymentPluginPlatform.instance.clearWallet();
  }

  Future<String?> logoutWallet() {
    return EntrustPaymentPluginPlatform.instance.logoutWallet();
  }

  Future<String?> connectWallet() {
    return EntrustPaymentPluginPlatform.instance.connectWallet();
  }

  Future<String?> enrollWallet({String? enrollCardData}) {
    return EntrustPaymentPluginPlatform.instance.enrollWallet(enrollCardData);
  }
}
