import 'package:entrust_payment_plugin/entrust_payment_plugin.dart';
import 'package:entrust_payment_plugin/wallet.dart';
import 'package:entrust_payment_plugin_example/common_button.dart';
import 'package:entrust_payment_plugin_example/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Wallet? myWallet;
  String clientId = "";
  String walletStatus = "";

  final _entrustNfcPlugin = EntrustPaymentPlugin();

  void enrollWallet() async {
    String? result;
    try {
      result = await _entrustNfcPlugin.enrollWallet(enrollCardData: "");
    } on PlatformException {
      result = null;
    }
  }

  void getWalletInfo() async {
    Wallet? result;
    try {
      result = await _entrustNfcPlugin.getWalletInfo();
      setState(() {
        myWallet = result;
      });
    } on PlatformException {
      result = null;
    }
  }

  void disconnectWallet() async {
    String result;
    try {
      result = await _entrustNfcPlugin.disconnectWallet() ?? "";
      // if (context.mounted) {
      //   Navigator.pushNamed(context, ScreenRoutes.toHome);
      // }
    } on PlatformException {
      result = "";
    }

    setState(() {
      walletStatus = result;
    });
  }

  void logoutWallet() async {
    String result;
    try {
      result = await _entrustNfcPlugin.logoutWallet() ?? "";
      if (context.mounted) {
        Navigator.pushNamed(context, ScreenRoutes.toHome);
      }
    } on PlatformException {
      result = "";
    }

    setState(() {
      walletStatus = result;
    });
  }

  void reconnectWallet() async {
    String result;
    try {
      result = await _entrustNfcPlugin.connectWallet() ?? "";
    } on PlatformException {
      result = "";
    }

    setState(() {
      walletStatus = result;
    });
  }

  void clearWallet() async {
    String result;
    try {
      result = await _entrustNfcPlugin.clearWallet() ?? "";
      if (context.mounted) {
        Navigator.pushNamed(context, ScreenRoutes.toHome);
      }
    } on PlatformException {
      result = "";
    }

    setState(() {
      walletStatus = result;
    });
  }

  @override
  void initState() {
    super.initState();
    getWalletInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text("wallet status $walletStatus"),
              const SizedBox(
                height: 20,
              ),
              Text("wallet id ${myWallet?.walletId}"),
              const SizedBox(
                height: 20,
              ),
              Text("client id ${myWallet?.issuerClientId}"),
              const SizedBox(
                height: 20,
              ),
              Text("Default card id ${myWallet?.defaultCardId}"),
              const SizedBox(
                height: 20,
              ),
              CommonButton(
                onPress: disconnectWallet,
                title: "Disconnect wallet",
              ),
              const SizedBox(
                height: 20,
              ),
              CommonButton(
                onPress: clearWallet,
                title: "Clear wallet",
              ),
              const SizedBox(
                height: 20,
              ),
              CommonButton(
                onPress: reconnectWallet,
                title: "Re-connect wallet",
              ),
              const SizedBox(
                height: 20,
              ),
              CommonButton(
                onPress: logoutWallet,
                title: "Logout wallet",
              ),
              const SizedBox(
                height: 20,
              ),
              CommonButton(
                onPress: enrollWallet,
                title: "Enroll Card",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
