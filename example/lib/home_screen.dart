import 'package:entrust_payment_plugin/entrust_payment_plugin.dart';
import 'package:entrust_payment_plugin_example/common_button.dart';
import 'package:entrust_payment_plugin_example/pin_enter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _entrustNfcPlugin = EntrustPaymentPlugin();
  String walletInitResult = "No-Initialize Yet";
  String walletProvisionedStatus = "";
  String walletStatus = "";
  String clientId = "";
  String walletId = "";

  Widget _spaceTop() {
    return const Padding(padding: EdgeInsets.only(top: 10));
  }

  Widget _titleText({required String text}) {
    return Text(
      text,
      style: const TextStyle(color: Colors.black, fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 60)),
              const Text(
                "Entrust SDK Test",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _spaceTop(),
              _titleText(text: "Wallet Status $walletInitResult"),
              _spaceTop(),
              CommonButton(
                onPress: initWallet,
                title: "Init Wallet",
              ),
              _spaceTop(),
              _spaceTop(),
              _titleText(
                  text: "Wallet provisioned status $walletProvisionedStatus"),
              _spaceTop(),
              CommonButton(
                onPress: provisionWallet,
                title: "Provision Wallet",
              ),
              _spaceTop(),
              // _titleText(text: "Wallet id $walletId"),
              _spaceTop(),
              CommonButton(
                onPress: () => connectWallet(context),
                title: "Connect Wallet",
              ),
              _spaceTop(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initWallet() async {
    String result;

    try {
      result = await _entrustNfcPlugin.initWallet() ?? "";
      print("Wallet init result --> " + result);
    } on PlatformException {
      result = "";
    }

    setState(() {
      walletInitResult = result;
    });
  }

  Future<void> provisionWallet() async {
    String result;
    try {
      result = await _entrustNfcPlugin.provisionWallet() ?? "";
      print("Wallet init result --> " + result);
    } on PlatformException {
      result = "";
    }

    setState(() {
      walletProvisionedStatus = result;
    });
  }

  Future<void> connectWallet(BuildContext context) async {
    // String result;
    // try {
    //   result = await _entrustNfcPlugin.connectWallet() ?? "";
    //   print("Wallet init result --> " + result);
    // } on PlatformException {
    //   result = "";
    // }

    // setState(() {
    //   walletId = result;
    // });

    openPinSheet(context: context);
  }
}
